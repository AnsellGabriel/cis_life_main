class ClaimCoveragesController < ApplicationController
  def new
    @process_claim = ProcessClaim.find(params[:v])
    @claim_coverage = @process_claim.claim_coverages.build
  end

  def edit
  end

  def create 

  end

  def update 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_claim_coverage
      @claim_coverage = ClaimCoverage.find(params[:id])
      @process_claim = @claim_coverage.process_claim
    end

    # Only allow a list of trusted parameters through.
    def claim_coverage_params
      params.require(:claim_coverage).permit(:process_claim_id, :batch, :amount_cover, :coverage_type, 
            batch_attributes: [:id, :effectivity, :expiry])
    end
end
