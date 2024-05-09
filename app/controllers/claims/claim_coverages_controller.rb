
class Claims::ClaimCoveragesController < ApplicationController
  before_action :set_claim_coverage, only: %i[ edit update destroy ]
  def new
    @process_claim = Claims::ProcessClaim.find(params[:v])
    @claim_coverage = @process_claim.claim_coverages.build
  end

  def edit
  end

  def create
    @process_claim = Claims::ProcessClaim.find(params[:v])
    @claim_coverage = @process_claim.claim_coverages.build(claim_coverage_params)
    # @claim_benefit = ClaimBenefit.new(claim_benefit_params)
    respond_to do |format|
      if @claim_coverage.save
        format.html { redirect_back fallback_location: @process_claim, notice: "Coverage was successfully created." }
        format.json { render :show, status: :created, location: @claim_benefit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @claim_benefit.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @claim_coverage.update(claim_coverage_params)
        format.html { redirect_back fallback_location: @process_claim, notice: "Coverage was successfully created." }
        format.json { render :show, status: :ok, location: @claim_coverage }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @claim_coverage.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @claim_coverage.destroy

    respond_to do |format|
      format.html { redirect_to claims_file_process_claim_path(@process_claim), notice: "Claim coverage was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_claim_coverage
    @claim_coverage = Claims::ClaimCoverage.find(params[:id])
    @process_claim = @claim_coverage.process_claim
  end

  # Only allow a list of trusted parameters through.
  def claim_coverage_params
    # params.require(:claim_coverage).permit(:process_claim_id, :batch, :amount_cover, :coverage_type,
          # batch_attributes: [:id, :effectivity, :expiry])
    params.require(:claims_claim_coverage).permit(:orno, :or_date, :bsno, :bs_date, :effectivity, :expiry, :amount, :amount_cover, :coverage_type, :status, :process_claim_id)
  end
end
