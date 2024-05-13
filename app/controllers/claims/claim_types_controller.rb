
class Claims::ClaimTypesController < ApplicationController
  before_action :set_claim_type, only: %i[ show edit update destroy ]

  # GET /claim_types
  def index
    @claim_types = Claims::ClaimType.all
  end

  # GET /claim_types/1
  def show
  end

  # GET /claim_types/new
  def new
    @claim_type = Claims::ClaimType.new
  end

  # GET /claim_types/1/edit
  def edit
  end

  # POST /claim_types
  def create
    @claim_type = Claims::ClaimType.new(claim_type_params)

    if @claim_type.save
      redirect_to claims_claim_types_path, notice: "Claim type was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /claim_types/1
  def update
    if @claim_type.update(claim_type_params)
      redirect_to claims_claim_types_path, notice: "Claim type was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /claim_types/1
  def destroy
    @claim_type.destroy
    redirect_to claims_claim_types_url, notice: "Claim type was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_claim_type
    @claim_type = Claims::ClaimType.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def claim_type_params
    params.require(:claims_claim_type).permit(:name, :description,
      claim_type_benefit_attributes: [:id, :benefit_id],
      claim_type_document_attributes: [:id, :document_id, :requred])
  end
end
