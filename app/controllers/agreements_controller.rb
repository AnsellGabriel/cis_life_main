class AgreementsController < InheritedResources::Base
  before_action :set_cooperative, only: %i[index new create show]

  def index 
    @agreements = @cooperative.agreements
  end

  def new
    @agreement = @cooperative.agreements.build(description: FFaker::Lorem.paragraph, premium: 1000, coop_service_fee: 10, agent_service_fee: 5, plan_id: 1)
  end

  def create
    @agreement = @cooperative.agreements.build(agreement_params)
    plan = Plan.find_by(id: agreement_params[:plan_id])
    # byebug
    @agreement.name = "#{plan.acronym}-Agreement-#{Agreement.last.id + 1}"

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
      params.require(:agreement).permit(:description, :premium, :coop_service_fee, :agent_service_fee, :plan_id, :anniversary_type)
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end
end
