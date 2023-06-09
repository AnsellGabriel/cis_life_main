class ProductBenefitsController < InheritedResources::Base

  private

    def product_benefit_params
      params.require(:product_benefit).permit(:coverage_amount, :premium, :agreement_benefit_id, :benefit_id, :duration, :residency_floor, :residency_ceiling)
    end

end
