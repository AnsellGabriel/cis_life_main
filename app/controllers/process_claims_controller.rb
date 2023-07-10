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
    @claim_documents = @process_claim.claim_documents.build
    @coop_member = CoopMember.find(params[:coop_member_id])
    @agreement = Agreement.find(params[:agreement_id])
    @group_remit = @agreement.group_remits.joins(:batches)
                           .where(batches: { coop_member_id: @coop_member.id })
                           .order('group_remits.created_at DESC')
                           .limit(1)
                           .first
    @batch = @group_remit.batches.find_by(coop_member_id: @coop_member.id)

  end

  # GET /process_claims/1/edit
  def edit
  end

  # POST /process_claims
  def create
    @process_claim = ProcessClaim.new(process_claim_params)

    batch = Batch.find(process_claim_params[:batch_id])
    coop_member = batch.coop_member
    agreement = Agreement.find(process_claim_params[:agreement_id])
    @group_remit = agreement.group_remits.joins(:batches)
                           .where(batches: { coop_member_id: coop_member.id })
                           .order('group_remits.created_at DESC')
                           .limit(1)
                           .first

    expiry_date = @group_remit.expiry_date
    incident_date = process_claim_params[:date_incident].to_date
    difference_in_months = (expiry_date.year * 12 + expiry_date.month) - (incident_date.year * 12 + incident_date.month) if incident_date != nil
    # byebug

    if difference_in_months != nil && difference_in_months > 60
      return redirect_to new_process_claim_path, alert: "The claim cannot be processed. The incident date has passed the 5-year claim period."
    end


    if @process_claim.save!
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
      params.require(:process_claim).permit(:cooperative_id, :agreement_id, :batch_id, :date_incident, :entry_type, :batch_beneficiary_id, :claimant_email, :claimant_contact_no, :nature_of_claim, claim_documents_attributes: [:id, :document, :document_type, :_destroy])
    end

end
