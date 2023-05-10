class AgreementBenefitsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type

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

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        redirect_to :authenticated_root, alert: "You don't have access to this page"
      end
    end

end
