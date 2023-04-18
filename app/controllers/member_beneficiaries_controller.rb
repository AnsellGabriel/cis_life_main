class MemberBeneficiariesController < InheritedResources::Base

  private

    def member_beneficiary_params
      params.require(:member_beneficiary).permit(:last_name, :first_name, :middle_name, :suffix, :birth_date, :relationship, :member_id, :batch_id)
    end

end
