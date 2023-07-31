class BatchDependentsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_group_remit_batch, only: %i[new create]
  before_action :set_dependent, only: %i[show edit update destroy]

  def show
    @dependent = @batch_dependent.member_dependent
  end

  def new
    @batch_dependent = @batch.batch_dependents.new
    @member = @batch.member_details
    @dependents = @member.unselected_dependents(@batch.dependent_ids)
  end

  def show_all
    @title = "List of Dependents"
    @group_remit = GroupRemit.find(params[:group_remit_id])
    @batch = Batch.find(params[:batch_id])
    @dependents = @batch.batch_dependents
  end


  def create
    group_remit = @batch.group_remits.find_by(id: params[:group_remit_id])
    terms = group_remit.terms
    agreement = group_remit.agreement
    term_insurance = agreement.plan.acronym == 'PMFC' ? true : false
    
    @batch_dependent = @batch.batch_dependents.new(batch_dependent_params)
    relationship = @batch_dependent.member_dependent.relationship
    insured_type = @batch_dependent.insured_type(relationship)

    dependent_agreement_benefits = agreement.agreement_benefits.where("name LIKE ?", "%#{@batch.agreement_benefit.name}%").find_by(insured_type: insured_type)


    @batch_dependent.set_premium_and_service_fees(dependent_agreement_benefits, group_remit, term_insurance) # model/concerns/calculate.rb

    respond_to do |format|
      if @batch_dependent.save
        format.html { redirect_to group_remit_batch_path(@group_remit, @batch), notice: "Dependent successfully added" }
      else
        format.html { redirect_to group_remit_batch_path(@group_remit, @batch), alert: @batch_dependent.errors.full_messages.join(', ') }
      end
    end
  end

  def destroy    
    respond_to do |format|
      if @batch_dependent.destroy
        format.html { redirect_to group_remit_batch_path(@group_remit, @batch), alert: "Dependent removed" }
      end
    end
  end

  private
    def batch_dependent_params
      params.require(:batch_dependent).permit(:member_dependent_id)
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
      unless current_user.userable_type == 'CoopUser' || current_user.userable_type == 'Employee'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end

end
