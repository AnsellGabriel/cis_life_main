class GroupRemitsController < InheritedResources::Base
  include Container
  include Counter
  include BatchesLoader

  before_action :authenticate_user!
  # before_action :check_userable_type
  before_action :set_group_remit, only: %i[show edit update destroy submit payment]
  before_action :set_members, only: %i[new create edit update]

  def renewal
    @group_remit = GroupRemit.find_by(id: params[:id])
    renewal_result = @group_remit.renew(current_user)
    new_group_remit = renewal_result[:new_group_remit]

    respond_to do |format|
      if @group_remit.present?
        format.html { redirect_to group_remit_path(new_group_remit), notice: "Group remit renewed" }
      end
    end
  end

  def submit
    if @group_remit.batches.empty?
      return redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), alert: "Unable to submit an empty lisy!"
    elsif @group_remit.mis_entry? && @group_remit.official_receipt.blank?
      return redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), alert: "Please enter the official receipt number!"
    end

    # if @group_remit.batches_all_renewal?
    #   @group_remit.approve_insurance_status_of_batches
    #   @group_remit.set_for_payment_status
    # else
    #   @group_remit.set_under_review_status
    # end

    begin
      ActiveRecord::Base.transaction do
        # Your transactional code here
        @group_remit.set_under_review_status
        @group_remit.date_submitted = Date.today
        @group_remit.save!

        create_process_coverage(@group_remit)
        @process_coverage.save!

        respond_to do |format|
          format.html { redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), notice: "Enrollment list submitted" }
        end
      end
    rescue StandardError => e
      # Handle the exception here
      respond_to do |format|
        format.html { redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), alert: "Unable to submit the list. No assigned underwriting analyst. Please contact the administrator" }
      end
    end



  end

  def index
    @agreement = Agreement.find_by(id: params[:agreement_id])
    @group_remits = @agreement.group_remits
  end

  def show
    load_data
    load_batches
    paginate_batches
  end

  def new
    @agreement = Agreement.find_by(id: params[:agreement_id])
    # @group_remit = @agreement.group_remits.build(
    #   name: FFaker::Company.name,
    #   description: FFaker::Lorem.paragraph,
    #   agreement_id: 1,
    #   anniversary_id: 1)
    @group_remit = @agreement.group_remits.build
  end

  def create
    @agreement = Agreement.find_by(id: params[:agreement_id])

    if params[:anniversary_id].present?
      pending_remittance = @agreement.group_remits.where(status: [:pending, :for_renewal]).remittances.where(anniversary_id: params[:anniversary_id]).last
    else
      pending_remittance = @agreement.group_remits.where(status: [:pending, :for_renewal]).remittances.last
    end

    if pending_remittance.present?
      return redirect_to coop_agreement_group_remit_path(@agreement, pending_remittance), alert: "Please complete the pending list first."
    end

    @group_remit = @agreement.group_remits.build(type: "Remittance")
    anniversary_date = set_anniversary(@agreement.anniversary_type, params[:anniversary_id])

    GroupRemit.process_group_remit(@group_remit, anniversary_date, params[:anniversary_id])

    respond_to do |format|
      if @group_remit.save!
        @group_remit.create_notification

        if params[:type] == "BatchRemit"
          batch_remit = @agreement.group_remits.build(type: "BatchRemit")

          GroupRemit.process_group_remit(batch_remit, anniversary_date, params[:anniversary_id])

          batch_remit.save!

          @group_remit.update!(batch_remit_id: batch_remit.id)
        else
          @group_remit.update!(batch_remit_id: params[:batch_remit_id])
        end

        if current_user.is_mis?
          @group_remit.update!(mis_entry: true)
        end

        format.html { redirect_to coop_agreement_group_remit_path(@agreement, @group_remit), notice: "Group remit was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @agreement = @group_remit.agreement
  end

  def update
    respond_to do |format|
      if @group_remit.update(group_remit_params)
        format.html { redirect_to @group_remit, notice: "Official receipt number updated" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    agreement = @group_remit.agreement

    respond_to do |format|
      if @group_remit.destroy!
        format.html { redirect_to coop_agreement_path(agreement), alert: "Group remit was successfully deleted." }
      end
    end
  end

  private

  def set_group_remit
    @group_remit = GroupRemit.includes(:batches).find(params[:id]).decorate
  end

  def set_members
    @members = Member.coop_member_details(@cooperative.coop_members)
  end

  def group_remit_params
    params.require(:group_remit).permit(:official_receipt, :name, :agreement_id, :anniversary_id,
      process_coverage_attributes: [:group_remit_id, :effectivity, :expiry], payments_attributes: [:id, :receipt, :_destroy] )
  end

  def set_anniversary(anniversary_type, anniv_id)
    if anniversary_type.downcase == "single" || anniversary_type.downcase == "multiple"
      anniv_date = @agreement.anniversaries.find_by(id: anniv_id)
      anniv_date.anniversary_date
    elsif (anniversary_type.downcase == "12 months" or anniversary_type.nil?)
      Date.today.prev_month.end_of_month.next_year
    end
  end

  def check_userable_type
    unless current_user.userable_type == "CoopUser"
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  def load_data
    @agreement = @group_remit.agreement.decorate
    @anniversary = @group_remit.anniversary
    load_concerns
  end

  def load_concerns
    containers # controller/concerns/container.rb
    counters  # controller/concerns/counter.rb
  end

  def create_process_coverage(group_remit)
    @process_coverage = group_remit.build_process_coverage
    @process_coverage.effectivity = group_remit.effectivity_date
    @process_coverage.expiry = group_remit.expiry_date
    @process_coverage.processor_id  = group_remit.agreement.emp_agreements.find_by(agreement: group_remit.agreement, active: true).employee_id
    @process_coverage.approver_id  = group_remit.agreement.emp_agreements.find_by(agreement: group_remit.agreement, active: true).employee.emp_approver.approver_id
    @process_coverage.set_default_attributes
  end
end
