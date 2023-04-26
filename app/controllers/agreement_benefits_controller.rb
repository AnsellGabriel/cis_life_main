class AgreementBenefitsController < InheritedResources::Base

  def selected
    # @target = params[:target]
    @agreement_benefit = AgreementBenefit.find(params[:id])
    @premium = @agreement_benefit.premium
    @coop_sf = (@agreement_benefit.coop_sf * @premium)
    @agent_sf = (@agreement_benefit.agent_sf * @premium)
    
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

    def agreement_benefit_params
      params.require(:agreement_benefit).permit(:name, :description, :premium, :coop_sf, :agent_sf)
    end

end
