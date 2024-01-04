class ClaimConfinementsController < ApplicationController
  before_action :set_claim_confinement, only: %i[ edit update destroy ]
  def new
    @process_claim = ProcessClaim.find(params[:v])
    @claim_confinement = @process_claim.claim_confinements.build
  end

  def create
    @process_claim = ProcessClaim.find(params[:v])
    @claim_confinement = @process_claim.claim_confinements.build(claim_confinement_params)
    @claim_confinement.terms = @claim_confinement.days_confinement
    @benefit = Benefit.find_by(name: "Hospital Income Benefit")
    @hib = ProductBenefit.find_by(agreement_benefit: @process_claim.agreement_benefit, benefit: @benefit)
    @claim_confinement.amount = @hib.coverage_amount * @claim_confinement.terms
    # raise "error"
    respond_to do |format|
      if @claim_confinement.save!
        compute_confinement
        format.html { redirect_back fallback_location: @process_claim, notice: "Confinement was successfully created." }
        format.json { render :show, status: :created, location: @claim_benefit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @claim_confinement.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    @claim_confinement.terms = @claim_confinement.days_confinement

    @hib = ProductBenefit.find_by(agreement_benefit: @process_claim.agreement_benefit, benefit: @benefit)
    @claim_confinement.amount = @hib.coverage_amount * @claim_confinement.terms
    respond_to do |format|
      if @claim_confinement.update(claim_confinement_params)
        # @process_claim.update!(claim_route: @claim_track.route_id, status: :process, claim_filed: 1, processing: 0, approval: 0, payment: 0)
        compute_confinement
        format.html { redirect_back fallback_location: @process_claim, notice: "Confinement was successfully created." }
        format.json { render :show, status: :ok, location: @claim_benefit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @claim_benefit.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @claim_confinement.destroy
    compute_confinement
    respond_to do |format|
      format.html { redirect_to show_coop_process_claim_path(@process_claim), notice: "Confinement was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def compute_confinement
    @claim_benefit = @process_claim.claim_benefits.where(benefit: @benefit)
    @claim_benefit.update!(amount: @process_claim.claim_confinements.sum(:amount)) unless @claim_benefit.nil?
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_claim_confinement
    @claim_confinement = ClaimConfinement.find(params[:id])
    @process_claim = @claim_confinement.process_claim
    @benefit = Benefit.find_by(name: "Hospital Income Benefit")
  end

  # Only allow a list of trusted parameters through.
  def claim_confinement_params
    params.require(:claim_confinement).permit(:process_claim_id, :date_admit, :date_discharge, :terms, :amount)
  end
end
