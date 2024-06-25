class Claims::ClaimTypeAgreementsController < ApplicationController
    before_action :set_claim_type_agreement, only: %i[ edit update destroy ]
    def index 
    end

    def new 
        @agreement = Agreement.find(params[:v])
        @claim_type_agreement = @agreement.claim_type_agreements.build
    end
    
    def create 
        @agreement = Agreement.find(params[:v])
        @claim_type_agreement = @agreement.claim_type_agreements.build(claim_type_agreement_params)

        respond_to do |format|
            if @claim_type_agreement.save
              format.html { redirect_to @agreement, notice: "Benefit claim was successfully created." }
              format.json { render :show, status: :created, location: @claim_benefit }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @claim_type_agreement.errors, status: :unprocessable_entity }
            #   format.turbo_stream { render :form_update, status: :unprocessable_entity }
            end
          end
    end

    def destroy 
        @claim_type_agreement.destroy

        respond_to do |format|
        format.html { redirect_to @agreement, notice: "Claim type agreement was successfully destroyed." }
        format.json { head :no_content }
        end
    end

    private
  # Use callbacks to share common setup or constraints between actions.
  def set_claim_type_agreement
    @claim_type_agreement = Claims::ClaimTypeAgreement.find(params[:id])
    @agreement = @claim_type_agreement.agreement
    # @claim_type = @claim_type_benefit.claim_type
  end

  # Only allow a list of trusted parameters through.
  def claim_type_agreement_params
    params.require(:claims_claim_type_agreement).permit(:claim_type_id, :agreement_id)
  end
end
