class AgreementsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_cooperative, only: %i[index new create show]

  def index 
    @agreements = @cooperative.agreements.order(updated_at: :desc)

    # filter members based on last name, first name
    @f_agreements = @agreements.where("name LIKE ?", "%#{params[:agreement_filter]}%")
    # @pagy, @agreements = pagy(@f_agreements, items: 8)
  end

  def show
    @agreement = Agreement.find(params[:id])
    @principal_premium = @agreement.agreement_benefits.find_by(insured_type: 1).product_benefit.premium
    @dependent_premium = @agreement.agreement_benefits.find_by(insured_type: 2).product_benefit.premium

    @coop_sf = @agreement.agreement_benefits[0].proposal.coop_sf
  end

  def new
    @agreement = @cooperative.agreements.build(description: FFaker::Lorem.paragraph, plan_id: 1)
  end

  def create
    @agreement = @cooperative.agreements.build(agreement_params)
    plan = Plan.find_by(id: agreement_params[:plan_id])
    @agreement.name = "#{plan.acronym}-Agreement-#{Agreement.count + 1}"
    @agreement.premium = agreement_params[:premium]
    @agreement.coop_service_fee = agreement_params[:coop_service_fee]
    @agreement.agent_service_fee = agreement_params[:agent_service_fee]

    respond_to do |format|
      if @agreement.save!
        format.html { redirect_to @agreement, notice: 'Agreement was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private

    def agreement_params
      params.require(:agreement).permit(:description, :coop_service_fee, :agent_service_fee, :plan_id, :agent_id, :anniversary_type, :agreement_type, :premium, :coop_service_fee, :agent_service_fee)
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
