class CoopMembersController < InheritedResources::Base
  def index
    @cooperative = current_user.userable.cooperative
    super
  end

  def new
    @cooperative = current_user.userable.cooperative
    @coop_member = CoopMember.new
    @beneficiary = @coop_member.coop_member_beneficiaries.build
    super
  end

  def edit
    @cooperative = current_user.userable.cooperative
    super
  end
  
  def show
    @coop_member = CoopMember.find(params[:id])
    @beneficiaries = @coop_member.coop_member_beneficiaries
    super
  end

  private

    def coop_member_params
      params.require(:coop_member).permit(:cooperative_id, :coop_branch_id, :last_name, :first_name, :middle_name, :suffix, :birthdate, :mobile_number, :email, :coop_member_beneficiaries_attributes => [:id, :last_name, :first_name, :middle_name, :suffix, :birthdate, :relationship, :coop_member_id, :_destroy])
    end

end
