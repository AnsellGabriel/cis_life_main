class CoopMemberDependentsController < InheritedResources::Base

  private

    def coop_member_dependent_params
      params.require(:coop_member_dependent).permit(:last_name, :first_name, :middle_name, :suffix, :birthdate, :coop_member_id, :relationship)
    end

end
