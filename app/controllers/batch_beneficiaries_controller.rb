class BatchBeneficiariesController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_group_remit_batch, only: %i[new create]
  before_action :set_beneficiary, only: %i[show edit update destroy]

  def show
    @dependent = @batch_beneficiary.member_dependent
  end

  def new
    @batch_beneficiary = @batch.batch_beneficiaries.new
    @member = @batch.member_details
    @beneficiaries = @member.unselected_dependents(@batch.beneficiary_ids)
  end

  def create
    @batch_beneficiary = @batch.batch_beneficiaries.new(batch_beneficiary_params)
    
    respond_to do |format|
      if @batch_beneficiary.save
        format.html { redirect_to group_remit_batch_path(@group_remit, @batch), notice: "Batch beneficiary was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy    
    respond_to do |format|
      if @batch_beneficiary.destroy
        format.html { redirect_to group_remit_batch_path(@group_remit, @batch), alert: "Batch beneficiary was successfully destroyed." }
      end
    end
  end


  private
    def batch_beneficiary_params
      params.require(:batch_beneficiary).permit(:batch_id, :member_dependent_id)
    end

    def set_group_remit_batch
      @group_remit = GroupRemit.find(params[:group_remit_id])
      @batch = @group_remit.batches.find(params[:batch_id])
    end

    def set_beneficiary
      set_group_remit_batch
      @batch_beneficiary = @batch.batch_beneficiaries.find(params[:id])
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
