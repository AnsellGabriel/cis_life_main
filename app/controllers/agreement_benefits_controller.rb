class AgreementBenefitsController < InheritedResources::Base

  private

    def agreement_benefit_params
      params.require(:agreement_benefit).permit(:name, :description)
    end

end
