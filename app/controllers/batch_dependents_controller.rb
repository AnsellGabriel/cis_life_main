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

  def create
    terms = @batch.group_remit.terms
    @batch_dependent = @batch.batch_dependents.new(batch_dependent_params)
    @batch_dependent.premium = ((@group_remit.dependent_premium / 12.to_d) * terms)

    @batch_dependent.coop_sf_amount = (@group_remit.get_coop_sf/100.to_d) * @batch_dependent.premium
    
    @batch_dependent.agent_sf_amount = (@group_remit.get_agent_sf/100.to_d) * @batch_dependent.premium

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
        format.html { redirect_to group_remit_batch_path(@group_remit, @batch), alert: "Batch dependent was successfully destroyed." }
      end
    end
  end

  private
    def set_group_remit_batch
      # @cooperative = current_user.userable.cooperative
      @group_remit = GroupRemit.find(params[:group_remit_id])
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
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end

end
