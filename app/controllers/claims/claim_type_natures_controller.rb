
class Claims::ClaimTypeNaturesController < ApplicationController
    before_action :set_claim_type_nature, only: %i[ show edit update destroy ]

    def show 

    end
    def new
        @claim_type = Claims::ClaimType.find(params[:p])
        @claim_type_nature = @claim_type.claim_type_natures.build
        # @claim_distribution.name = FFaker::NamePH.name if Rails.env.development?
    end
    
    def create 
        @claim_type = Claims::ClaimType.find(params[:p])
        @claim_type_nature = @claim_type.claim_type_natures.build(claim_type_nature_params)
        # @claim_benefit = ClaimBenefit.new(claim_benefit_params)
        respond_to do |format|
            if @claim_type_nature.save
                format.html { redirect_back fallback_location: @process_claim, notice: "Coverage was successfully created." }
                # format.json { render :show, status: :created, location: @claim_distribution }
            else
                format.html { render :new, status: :unprocessable_entity }
                format.json { render json: @claim_type_nature.errors, status: :unprocessable_entity }
                format.turbo_stream { render :form_update, status: :unprocessable_entity }
            end
        end
    end

    def edit 

    end

    def update 
        respond_to do |format|
            if @claim_type_nature.update(claim_type_nature_params)
              format.html { redirect_to @claim_type, notice: "Document was successfully updated." }
              format.json { render :show, status: :ok, location: @claim_benefit }
            else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: @claim_type_nature.errors, status: :unprocessable_entity }
              format.turbo_stream { render :form_update, status: :unprocessable_entity }
            end
          end
    end

    def destroy 
        @claim_type_nature.destroy

    respond_to do |format|
      format.html { redirect_to @claim_type, notice: "Claim benefit was successfully destroyed." }
      format.json { head :no_content }
    end
    end
    

    private
  # Use callbacks to share common setup or constraints between actions.
  def set_claim_type_nature
    @claim_type_nature = Claims::ClaimTypeNature.find(params[:id])
    @claim_type = @claim_type_nature.claim_type
  end

  # Only allow a list of trusted parameters through.
  def claim_type_nature_params
    # params.require(:claim_coverage).permit(:process_claim_id, :batch, :amount_cover, :coverage_type,
          # batch_attributes: [:id, :effectivity, :expiry])
    params.require(:claims_claim_type_nature).permit(:name, :description, :claim_type_id)
  end
end
