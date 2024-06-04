class AgreementsController < ApplicationController
  before_action :authenticate_user!
  # before_action :check_employee
  before_action :set_agreement, only: %i[ show edit update destroy show_details update_ors ]

  # GET /agreements
  def index
    @plans = Plan.all
    @agreements_x = Agreement.all

    
    if params[:search].present?
      @agreements = @agreements_x.filtered(params[:search])
    else
      @agreements = @agreements_x
    end

    if params[:f].present?
      @agreements = @agreements_x.joins(:plan).where(plan: { id: params[:f] })
    end
    # @agreements = Agreement.all
  end

  # GET /agreements/1
  def show
    @agreement_benefits = AgreementBenefit.where(agreement: @agreement)
  end

  def show_details
  end

  def update_ors
    @ors = Treasury::CashierEntry.get_ors(@agreement)
    if @ors.update(agreement: @agreement)
      redirect_to @agreement, notice: "O.Rs agreement updated!"
    else
      redirect_to @agreement, alert: "No O.Rs to be updated!"
    end

  end

  # GET /agreements/new
  def new
    # @agreement = Agreement.new(contestability: 12, nel: 25000, nml: 5000000, entry_age_from: 18, entry_age_to: 65, exit_age: 65)
    if current_user.userable_type == "Agent"
      @agreement = current_user.userable.agreements.build
    else
      @agreement = Agreement.new()
    end
    # @agreement.agreement_benefits.build
    # @agreement.loan_rates.build
    set_dummy_value
  end

  # GET /agreements/1/edit
  def edit
  end

  # POST /agreements
  def create
    if current_user.userable_type == "Agent"
      @agreement = current_user.userable.agreements.build
    else
      @agreement = Agreement.new(agreement_params)
      @agreement.emp_agreements.build(
        employee: current_user.userable,
        category_type: :main_approver,
        team: current_user.userable.team
      )
    end

    if @agreement.save!
      redirect_to @agreement, notice: "Agreement was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /agreements/1
  def update
    if @agreement.update(agreement_params)
      redirect_to @agreement, notice: "Agreement was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /agreements/1
  def destroy
    @agreement.destroy
    redirect_to agreements_url, notice: "Agreement was successfully destroyed."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_agreement
    @agreement = Agreement.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def agreement_params
    # params.require(:agreement).permit(:plan_id, :cooperative_id, :proposal_id, :agent_id, :moa_no, :contestability, :nel, :nml, :anniversary_type, :transferred, :transferred_date, :previous_provider, :comm_type, :claims_fund, :entry_age_from, :entry_age_to, :exit_age)
    params.require(:agreement).permit(:plan_id, :cooperative_id, :agent_id, :moa_no, :contestability, :nel, :nml, :anniversary_type, :transferred, :transferred_date, :previous_provider, :comm_type, :claims_fund, :claims_fund_amount, :entry_age_from, :entry_age_to, :exit_age, :coop_sf, :agent_sf, :minimum_participation, :reconsiderable, :unusable, :with_markup,
      agreement_benefits_attributes: [:id, :name, :plan_id, :description, :min_age, :max_age, :exit_age, :insured_type, :with_dependent, :_destroy],
      anniversaries_attributes: [:id, :name, :anniversary_date, :_destroy],
      loan_rates_attributes: [:id, :min_age, :max_age, :monthly_rate, :annual_rate, :min_amount, :max_amount, :coop_sf, :agent_sf, :_destroy])
  end

  def set_dummy_value
    @agreement.contestability = 12
    @agreement.nel  = 25000
    @agreement.nml = 5000000
  end
end
