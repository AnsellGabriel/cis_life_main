class MemberDependentsController < InheritedResources::Base
  before_action :set_member
  before_action :set_member_dependent, only: [:show, :edit, :update, :destroy]

  def index
    @member_dependents = @member.member_dependents
  end

  def new
    @member_dependent = @member.member_dependents.build
  end

  def create
    @member_dependent = @member.member_dependents.build(member_dependent_params)
    
    respond_to do |format|
      if @member_dependent.save
        format.html { redirect_to new_group_remit_batch_dependent_path(@group_remit, @batch), notice: "Member dependent was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @member_dependent.update(member_dependent_params)
        format.html { redirect_to member_dependents_path(@member), notice: "Member dependent was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @member_dependent.destroy
    respond_to do |format|
      format.html { redirect_to member_member_dependents_path(@member), notice: "Member dependent was successfully destroyed." }
    end
  end

  private

    def set_group_remit_batch
      @cooperative = current_user.userable.cooperative
      @group_remit = @cooperative.group_remits.find(params[:group_remit_id])
      @batch = @group_remit.batches.find(params[:batch_id])
    end

    def set_member
      set_group_remit_batch
      @coop_member = @batch.coop_member
      @member = @coop_member.member
    end

    def set_member_dependent
      @member_dependent = @member.member_dependents.find(params[:id])
    end

    def member_dependent_params
      params.require(:member_dependent).permit(:last_name, :first_name, :middle_name, :suffix, :birth_date, :relationship)
    end

# Path: app/controllers/members_controller.rb
# Compare this snippet from app/controllers/member_dependents_controller.rb:
# class MemberDependentsController < InheritedResources::Base
#   before_action :set_member
#   before_action :set_member_dependent, only: [:show, :edit, :update, :destroy]
# 
#   def index
#     @member_dependents = @member.member_dependents
#   end
# 
#   def new
#     @member_dependent = @member.member_dependents.build
#   end
# 
#   def create
  private

    def member_dependent_params
      params.require(:member_dependent).permit(:last_name, :first_name, :middle_name, :suffix, :birth_date, :relationship, :member_id)
    end

end
