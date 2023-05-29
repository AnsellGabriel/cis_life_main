class AgreementsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_agreement, only: %i[show edit update destroy]

  def index 
    # filtered @cooperative.agreements
    @f_agreements = @cooperative.filtered_agreements(params[:agreement_filter])
  end

  def show
    @group_remits = @agreement.group_remits
    @coop_sf = @agreement.get_coop_sf

    expiry_dates = @group_remits.pluck(:expiry_date).map { |date| date.strftime("%m-%d") }
    @anniversaries = @agreement.get_filtered_anniversaries(expiry_dates)
  end

  def new
    @agreement = @cooperative.agreements.build(description: FFaker::Lorem.paragraph, plan_id: 1)
  end

  def create
    plan = Plan.find_by(id: agreement_params[:plan_id])
    @agreement = @cooperative.agreements.build(agreement_params)
    @agreement.moa_no = "#{plan.acronym}-Agreement-#{Agreement.count + 1}"

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

    def set_agreement
      @agreement = Agreement.find(params[:id])
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
