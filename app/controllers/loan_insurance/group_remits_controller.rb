class LoanInsurance::GroupRemitsController < ApplicationController
  include BatchesLoader

  before_action :set_agreement, only: %i[index new create show]
  before_action :set_group_remit, only: %i[submit show destroy]

  def index
    @q = @agreement.group_remits.loan_remits.order(created_at: :desc).ransack(params[:q])
    @group_remits = @q.result(distinct: true)
    @group_remit_size = @group_remits.size
    @pagy, @group_remits = pagy(@group_remits, items: 10)
  end

  def submit
    if @group_remit.batches.empty?
      return redirect_to loan_insurance_group_remit_path(@group_remit), alert: "Unable to submit empty group remit!"
    elsif @group_remit.mis_entry? && @group_remit.official_receipt.blank?
      return redirect_to loan_insurance_group_remit_path(@group_remit), alert: "Please enter the official receipt number!"
    end

    @group_remit.set_under_review_status
    @group_remit.date_submitted = Date.today
    # @group_remit.terminate_unused_batches(current_user)

    respond_to do |format|
      if @group_remit.save!
        @process_coverage = @group_remit.build_process_coverage
        @process_coverage.effectivity = @group_remit.effectivity_date
        @process_coverage.expiry = @group_remit.expiry_date
        @process_coverage.processor_id  = @group_remit.agreement.emp_agreements.find_by(agreement: @group_remit.agreement, active: true).employee_id
        @process_coverage.approver_id  = @group_remit.agreement.emp_agreements.find_by(agreement: @group_remit.agreement, active: true).employee.emp_approver.approver_id
        @process_coverage.set_default_attributes
        @process_coverage.save!
        # raise 'errors'
        format.html { redirect_to loan_insurance_group_remit_path(@group_remit), notice: "Group remit submitted" }
        # else
        #   format.html { redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), alert: "Process Coverage not created!" }
        #   @group_remit.status = :pending
        #   @group_remit.save!
        # else
        #   format.html { redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), alert: "Please see members below and complete the necessary details." }
      end
    end
  end

  def show
    @batch = @group_remit.batches.build(premium: 0)
    @coop_members = @cooperative.coop_members

    load_batches
    paginate_batches

    @batch_with_health_dec = @group_remit.batches_without_health_dec
  end

  def new
    @group_remit = @agreement.group_remits.new(type: "LoanInsurance::GroupRemit", name: "#{Date.today.day}#{Date.today.strftime("%B").upcase}#{Date.today.year}")
  end

  def create
    @group_remit = @agreement.group_remits.new(group_remit_params)
    @group_remit.type = "LoanInsurance::GroupRemit"

    if current_user.is_mis?
      @group_remit.mis_entry = true
    end

    begin
      if @group_remit.save!
        redirect_to loan_insurance_group_remits_path, notice: "New batch created"
      else
        render :new
      end
    rescue ActiveRecord::RecordInvalid => e
      redirect_to loan_insurance_group_remits_path, alert: e.message.gsub(/^Validation failed: /, "")
    end
  end

  def edit_or
    @group_remit = LoanInsurance::GroupRemit.find(params[:id])
  end

  def update
    @group_remit = LoanInsurance::GroupRemit.find(params[:id])

    if @group_remit.update(group_remit_params)
      redirect_to loan_insurance_group_remit_path(@group_remit), notice: "Official Receipt updated"
    else
      render :edit_or
    end
  end

  def destroy
    if @group_remit.destroy!
      redirect_to loan_insurance_group_remits_path, alert: "Remittance deleted"
    end
  end

  private
  # create a secure params
  def group_remit_params
    params.require(:loan_insurance_group_remit).permit(:name, :type, :official_receipt)
  end

  def set_agreement
    @agreement = @cooperative.agreements.lppi.decorate
  end

  def set_group_remit
    @group_remit = LoanInsurance::GroupRemit.find(params[:id]).decorate
  end
end
