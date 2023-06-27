class ProcessClaimsController < ApplicationController
  before_action :set_process_claim, only: %i[ show edit update destroy ]

  # GET /process_claims
  def index
    @process_claims = ProcessClaim.all
  end

  # GET /process_claims/1
  def show
  end

  # GET /process_claims/new
  def new
    @process_claim = ProcessClaim.new
  end

  # GET /process_claims/1/edit
  def edit
  end

  # POST /process_claims
  def create
    @process_claim = ProcessClaim.new(process_claim_params)

    if @process_claim.save
      redirect_to @process_claim, notice: "Process claim was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /process_claims/1
  def update
    if @process_claim.update(process_claim_params)
      redirect_to @process_claim, notice: "Process claim was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /process_claims/1
  def destroy
    @process_claim.destroy
    redirect_to process_claims_url, notice: "Process claim was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_claim
      @process_claim = ProcessClaim.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def process_claim_params
      params.require(:process_claim).permit(:cooperative_id, :agreement_id, :batch_id, :date_incident, :entry_type)
    end
end
