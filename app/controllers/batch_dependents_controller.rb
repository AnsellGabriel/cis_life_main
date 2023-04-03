class BatchDependentsController < InheritedResources::Base

  private

    def batch_dependent_params
      params.require(:batch_dependent).permit(:batch_id, :coop_dependent_id, :premium, :agreement_benefit_id)
    end

end
