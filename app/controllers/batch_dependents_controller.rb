class BatchDependentsController < InheritedResources::Base
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
    
    respond_to do |format|
      if @batch_dependent.save
        format.html { redirect_to group_remit_batch_path(@group_remit, @batch), notice: "Batch dependent was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # member dependent enrollment action
  # def enroll_dependent
  #   @member_dependent = @member.member_dependents.build(member_dependent_params)

  #   respond_to do |format|
  #     if @member_dependent.save
  #       format.html { redirect_to member_dependents_path(@member), notice: "Member dependent was successfully created." }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #     end
  #   end
  # end

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

end
