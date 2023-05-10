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
    @member = @batch.coop_member.member
    @dependents = @member.member_dependents
  end

  def create
    @batch_dependent = @batch.batch_dependents.new(batch_dependent_params)
    
    premium = @group_remit.agreement.premium
    coop_sf = @group_remit.agreement.coop_service_fee
    agent_sf = @group_remit.agreement.agent_service_fee
    terms = @batch.group_remit.terms

    @batch_dependent.premium = ((premium / 12) * terms) 
    @batch_dependent.coop_sf_amount = (coop_sf/100) * @batch_dependent.premium
    @batch_dependent.agent_sf_amount = (agent_sf/100) * @batch_dependent.premium

    respond_to do |format|
      if @batch_dependent.save
        format.html { redirect_to group_remit_batch_path(@group_remit, @batch), notice: "Batch dependent was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy    
    respond_to do |format|
      if @batch_dependent.destroy
        format.html { redirect_to group_remit_batch_path(@group_remit, @batch), notice: "Batch beneficiary was successfully destroyed." }
      end
    end
  end

  private
    def set_group_remit_batch
      @cooperative = current_user.userable.cooperative
      @group_remit = @cooperative.group_remits.find(params[:group_remit_id])
      @batch = @group_remit.batches.find(params[:batch_id])
    end

    def set_dependent
      set_group_remit_batch
      @batch_dependent = @batch.batch_dependents.find(params[:id])
    end

    def batch_dependent_params
      params.require(:batch_dependent).permit(:batch_id, :premium, :member_dependent_id, :is_beneficiary, :is_dependent)
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        redirect_to root_path, alert: "You don't have access to this page"
      end
    end

end
