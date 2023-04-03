class CoopMembersController < InheritedResources::Base

  private

    def coop_member_params
      params.require(:coop_member).permit(:cooperative_id, :coop_branch_id, :last_name, :first_name, :middle_name, :suffix, :birthdate, :mobile_number, :email)
    end

end
