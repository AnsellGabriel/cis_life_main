class AgreementsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_cooperative, only: %i[index new create show]
  before_action :set_agreement, only: %i[show edit update destroy]

  def index 
    @agreements = @cooperative.agreements.order(updated_at: :desc)

    # filter members based on last name, first name
    @f_agreements = @agreements.where("moa_no LIKE ?", "%#{params[:agreement_filter]}%")
    # @pagy, @agreements = pagy(@f_agreements, items: 8)
  end

  def show
    if @agreement.plan.acronym == 'GYRTBR'
      insured_type = 3
    elsif @agreement.plan.acronym == 'GYRT'
      insured_type = 1
    elsif @agreement.plan.acronym == 'GYRTF'
      insured_type = 1
      dependent_type = 2
    end
      
    @principal_premium = @agreement.get_premium(insured_type)
    @dependent_premium = @agreement.get_premium(dependent_type) if @agreement.plan.acronym == 'GYRTF'
    @group_remit = @agreement.group_remits[0]
    @coop_sf = @agreement.get_coop_sf
    @group_remits = @agreement.group_remits

    expiry_dates = @group_remits.map { |group_remit| group_remit.expiry_date.strftime("%m-%d") }
    @anniversaries = @agreement.anniversaries.reject do |anniv|
      expiry_dates.present? ? expiry_dates.include?(anniv.anniversary_date.strftime("%m-%d")) : next
    end
    # byebug

    
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

    def set_cooperative
      @cooperative = current_user.userable.cooperative
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
