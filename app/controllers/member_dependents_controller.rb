class MemberDependentsController < InheritedResources::Base

  private

    def member_dependent_params
      params.require(:member_dependent).permit(:last_name, :first_name, :middle_name, :suffix, :birth_date, :relationship, :member_id)
    end

end
