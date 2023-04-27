class AgreementsController < InheritedResources::Base

  private

    def agreement_params
      params.require(:agreement).permit(:name, :description, :premium, :coop_service_fee, :agent_service_fee)
    end

end
