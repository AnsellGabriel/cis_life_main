class AgreementBenefitsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type

  def selectedx
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
      params.require(:agreement_benefit).permit(:name, :description, :min_age, :max_age, :agreement_id, :proposal_id)
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end

end
