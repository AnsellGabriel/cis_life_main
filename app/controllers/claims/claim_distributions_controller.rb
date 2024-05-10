class Claims::ClaimDistributionsController < ApplicationController
    before_action :set_claim_distribution, only: %i[ edit update destroy ]

    def new 
        @process_claim = Claims::ProcessClaim.find(params[:v])
        @claim_distribution = @process_claim.claim_distributions.build
        @claim_distribution.name = FFaker::NamePH.name if Rails.env.development?
    end
    
    def create 
        @process_claim = Claims::ProcessClaim.find(params[:v])
        @claim_distribution = @process_claim.claim_distributions.build(claim_distribution_params)
        # @claim_benefit = ClaimBenefit.new(claim_benefit_params)
        respond_to do |format|
            if @claim_distribution.save
                format.html { redirect_back fallback_location: @process_claim, notice: "Coverage was successfully created." }
                # format.json { render :show, status: :created, location: @claim_distribution }
            else
                format.html { render :new, status: :unprocessable_entity }
                format.json { render json: @claim_distribution.errors, status: :unprocessable_entity }
                format.turbo_stream { render :form_update, status: :unprocessable_entity }
            end
        end
    end

    def edit 

    end

    def update 
        respond_to do |format|
            if @claim_distribution.update(claim_distribution_params)
              format.html { redirect_back fallback_location: @process_claim, notice: "Coverage was successfully created." }
              format.json { render :show, status: :ok, location: @claim_distribution }
            else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: @claim_distribution.errors, status: :unprocessable_entity }
              format.turbo_stream { render :form_update, status: :unprocessable_entity }
            end
        end
    end

    def destroy 
        @claim_distribution.destroy

        respond_to do |format|
        format.html { redirect_to claims_file_process_claim_path(@process_claim), notice: "Claim coverage was successfully destroyed." }
        format.json { head :no_content }
        end
    end

    private
  # Use callbacks to share common setup or constraints between actions.
  def set_claim_distribution
    @claim_distribution = Claims::ClaimDistribution.find(params[:id])
    @process_claim = @claim_distribution.process_claim
  end

  # Only allow a list of trusted parameters through.
  def claim_distribution_params
    # params.require(:claim_coverage).permit(:process_claim_id, :batch, :amount_cover, :coverage_type,
          # batch_attributes: [:id, :effectivity, :expiry])
    params.require(:claims_claim_distribution).permit(:name, :relationship, :amount, :process_claim_id)
  end
end
