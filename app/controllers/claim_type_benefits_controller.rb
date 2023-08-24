class ClaimTypeBenefitsController < ApplicationController
  before_action :set_claim_type_benefit, only: %i[ edit update destroy ]
  def new
    @claim_type = ClaimType.find(params[:p])
    @claim_type_benefit = @claim_type.claim_type_benefits.build
  end

  def create 
    @claim_type = ClaimType.find(params[:p])
    @claim_type_benefit = @claim_type.claim_type_benefits.build(claim_type_benefit_params)
    # @claim_benefit = ClaimBenefit.new(claim_benefit_params)
    respond_to do |format|
      if @claim_type_benefit.save
        format.html { redirect_to @claim_type, notice: "Document was successfully added." }
        # format.json { render :show, status: :created, location: @claim_type_document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @claim_type_benefit.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update 
    respond_to do |format|
      if @claim_type_benefit.update(claim_type_benefit_params)
        format.html { redirect_to @claim_type, notice: "Document was successfully updated." }
        format.json { render :show, status: :ok, location: @claim_benefit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @claim_type.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @claim_type_benefit.destroy

    respond_to do |format|
      format.html { redirect_to @claim_type, notice: "Claim benefit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_claim_type_benefit
      @claim_type_benefit = ClaimTypeBenefit.find(params[:id])
      @claim_type = @claim_type_benefit.claim_type
    end

    # Only allow a list of trusted parameters through.
    def claim_type_benefit_params
      params.require(:claim_type_benefit).permit(:claim_type_id, :benefit_id)
    end
end
