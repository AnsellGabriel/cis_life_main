class AgreementsController < ApplicationController
  before_action :set_agreement, only: %i[ show edit update destroy ]

  # GET /agreements
  def index
    @agreements = Agreement.all
  end

  # GET /agreements/1
  def show
  end

  # GET /agreements/new
  def new
    @agreement = Agreement.new(contestability: 12, nel: 25000, nml: 5000000, entry_age_from: 18, entry_age_to: 65, exit_age: 65)
  end

  # GET /agreements/1/edit
  def edit
  end

  # POST /agreements
  def create
    # raise 'errors'
    @agreement = Agreement.new(agreement_params)

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
      params.require(:agreement).permit(:plan_id, :cooperative_id, :proposal_id, :agent_id, :moa_no, :contestability, :nel, :nml, :anniversary_type, :transferred, :transferred_date, :previous_provider, :comm_type, :claims_fund, :entry_age_from, :entry_age_to, :exit_age)
    end
end
