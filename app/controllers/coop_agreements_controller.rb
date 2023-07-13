class CoopAgreementsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_agreement, only: %i[ show edit update destroy ]

  # GET /agreements
  def index
    # @agreements = Agreement.all
    @agreements = @cooperative.filtered_agreements(params[:agreement_filter])

  end

  # GET /agreements/1
  def show
    @group_remits_eager = @agreement.group_remits.joins(:anniversary)
    # @group_remits = @agreement.group_remits.order(created_at: :desc)
    @coop_sf = @agreement.coop_sf
    @filtered_anniversaries = @agreement.get_filtered_anniversaries(@agreement.group_remits.expiry_dates)
  end

  # GET /agreements/new
  def new
    @agreement = @cooperative.agreements.build(description: FFaker::Lorem.paragraph, plan_id: 1)
  end

  # GET /agreements/1/edit
  def edit
  end

  # POST /agreements
  def create
    plan = Plan.find_by(id: agreement_params[:plan_id])
    @agreement = @cooperative.agreements.build(agreement_params)
    @agreement.moa_no = "#{plan.acronym}-Agreement-#{Agreement.count + 1}"

    if @agreement.save
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
      params.require(:agreement).permit(:plan_id, :cooperative_id, :agent_id, :moa_no, :contestability, :nel, :nml, :anniversary_type, :transferred, :transferred_date, :previous_provider, :comm_type, :claims_fund, :entry_age_from, :entry_age_to, :exit_age)
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
