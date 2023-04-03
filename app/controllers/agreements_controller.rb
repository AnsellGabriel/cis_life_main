class AgreementsController < InheritedResources::Base

  private

    def agreement_params
      params.require(:agreement).permit(:name, :description)
    end

end
