class ClaimBenefitsController < ApplicationController
  before_action :set_claim_benefit, only: %i[ edit update destroy ]

  def new
    @process_claim = ProcessClaim.find(params[:v])
    @claim_benefit = @process_claim.claim_benefits.build
  end

  def create
    @process_claim = ProcessClaim.find(params[:v])
    @claim_benefit = @process_claim.claim_benefits.build(claim_benefit_params)
    # @claim_benefit = ClaimBenefit.new(claim_benefit_params)
    respond_to do |format|
      if @claim_benefit.save
        format.html { redirect_back fallback_location: @process_claim, notice: "Benefit claim was successfully created." }
        format.json { render :show, status: :created, location: @claim_benefit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @claim_benefit.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @claim_benefit.update(claim_benefit_params)
        format.html { redirect_back fallback_location: @process_claim, notice: "Benefit claim was successfully created." }
        format.json { render :show, status: :ok, location: @claim_benefit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @claim_benefit.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @claim_benefit.destroy

    respond_to do |format|
      format.html { redirect_to claim_benefits_url, notice: "Claim benefit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_claim_benefit
    @claim_benefit = ClaimBenefit.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def claim_benefit_params
    params.require(:claim_benefit).permit(:process_claim_id, :benefit_id, :amount, :status)
  end
end
