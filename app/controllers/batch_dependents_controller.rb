class BatchDependentsController < InheritedResources::Base
  before_action :authenticate_user!
  # before_action :check_userable_type
  before_action :set_group_remit_batch, only: %i[new create]
  before_action :set_dependent, only: %i[show edit update destroy health_dec]

  def show
    @dependent = @batch_dependent.member_dependent
  end

  def new
    @batch_dependent = @batch.batch_dependents.new
    @member = @batch.member_details
    @dependents = @member.unselected_dependents(@batch.dependent_ids)

    if params[:error]
      @batch_dependent.errors.add(:base, 'Dependent already exist')
    end
  end

  def show_all
    @title = "List of Dependents"
    @group_remit = GroupRemit.find(params[:group_remit_id])
    @batch = Batch.find(params[:batch_id])
    @dependents = @batch.batch_dependents
  end

  def create
    group_remit = @batch.group_remits.find_by(id: params[:group_remit_id])
    agreement = group_remit.agreement

    begin
      insured_type = initialize_dependent_and_insured_type
    rescue NoMethodError
      return redirect_to group_remit_batch_path(@group_remit, @batch), alert: "Please choose a dependent"
    end

    # ! dependent agreement benefits' prefix must be principal agreement benefit's name
    dependent_agreement_benefits = agreement.agreement_benefits
                                    .with_name_like(@batch.agreement_benefit.name)
                                    .find_by(insured_type: insured_type)

    unless dependent_agreement_benefits.present?
      dependent_agreement_benefits = agreement.agreement_benefits.find_by(insured_type: insured_type)
    end
    # model/concerns/calculate.rb
    @batch_dependent.set_premium_and_service_fees(dependent_agreement_benefits, group_remit)
    dependent = @batch_dependent.member_dependent

    if dependent.age < @batch_dependent.agreement_benefit.min_age or dependent.age > @batch_dependent.agreement_benefit.max_age

      # return redirect_to group_remit_path(@group_remit), alert: "Member age must be between #{@batch.agreement_benefit.min_age.to_i} and #{@batch.agreement_benefit.max_age.to_i} years old."
      @batch_dependent.insurance_status = :denied
      if dependent.age > @batch_dependent.agreement_benefit.max_age
        @batch_dependent.batch_remarks.build(remark: "Member age is over the maximum age limit of the plan.", status: :denied, user_type: current_user.userable_type, user_id: current_user.userable.id)
      else
        @batch_dependent.batch_remarks.build(remark: "Member age is below the minimum age limit of the plan.", status: :denied, user_type: current_user.userable_type, user_id: current_user.userable.id)
      end
    end

    if @batch_dependent.save
      redirect_to group_remit_batch_path(@group_remit, @batch)
    else
      redirect_to group_remit_batch_path(@group_remit, @batch), alert: @batch_dependent.errors.full_messages.join(", ")
    end

    if @batch_dependent.denied?
      flash[:alert] = "Dependent denied. Please check the remarks"
    else
      flash[:notice] = "Dependent successfully added"
    end
  end

  def edit
  end

  def update
    @batch_dependent.manual_premium_and_fees(batch_dependent_params[:premium], @group_remit)

    respond_to do |format|
      if @batch_dependent.save!
        format.html {
          redirect_to group_remit_batch_path(@group_remit, @batch), notice: "Premium updated"
        }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @batch_dependent.destroy!
      redirect_to group_remit_batch_path(@group_remit, @batch), alert: "Dependent removed"
    end
  end

  def health_dec
    @dependent = @batch_dependent.member_dependent
    @dependent_health_dec = @batch_dependent.health_declaration
    @group_remit = @batch_dependent.batch.group_remits.find_by(type: "Remittance")
    @questionaires = BatchHealthDec.where(healthdecable: @batch_dependent).where(answerable_type: "HealthDec")
    @subquestions = BatchHealthDec.where(healthdecable: @batch_dependent).where(answerable_type: "HealthDecSubquestion")

    @for_und = params[:for_und]
    # @md = params[:md]

    # # Medical Director Remarks
    # @batch_remark = @batch.batch_remarks.build
    # @batch_status = "test"
    # @batch_status = "MD"
    # @rem_status = :md_reco
    # # @process_coverage = @batch.group_remit.process_coverage
    # @process_coverage = @group_remit.process_coverage

  end

  private
  def batch_dependent_params
    params.require(:batch_dependent).permit(:member_dependent_id, :premium)
  end

  def set_group_remit_batch
    @group_remit = GroupRemit.find(params[:group_remit_id])
    @batch = @group_remit.batches.find(params[:batch_id])
  end

  def set_dependent
    set_group_remit_batch
    @batch_dependent = @batch.batch_dependents.find(params[:id])
  end

  def check_userable_type
    unless current_user.userable_type == "CoopUser" || current_user.userable_type == "Employee"
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  def initialize_dependent_and_insured_type
    @batch_dependent = @batch.batch_dependents.new(batch_dependent_params)
    relationship = @batch_dependent.member_dependent.relationship
    insured_type = @batch_dependent.insured_type(relationship)
  end

end
