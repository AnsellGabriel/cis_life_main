class ClaimAttachmentsController < ApplicationController
  before_action :set_claim_attachment, only: %i[ edit update destroy ]

  def new
    @process_claim = ProcessClaim.find(params[:p])
    @claim_type_document = ClaimTypeDocument.find(params[:d])
    @claim_attachment = @process_claim.claim_attachments.build

    @claim_attachment.process_claim = @process_claim
    @claim_attachment.claim_type_document = @claim_type_document
  end

  def create
    @process_claim = ProcessClaim.find(params[:v])

    # redirect if file is empty
    if params[:claim_attachment][:doc].blank?
      return redirect_to show_coop_process_claim_path(@process_claim.id) , alert: "No file uploaded."
    end

    @claim_attachment = @process_claim.claim_attachments.build(claim_attachment_params)
    # @claim_benefit = ClaimBenefit.new(claim_benefit_params)
    respond_to do |format|
      # raise 'errors'
      if @claim_attachment.save
        format.html { redirect_to show_coop_process_claim_path(@process_claim.id) , notice: "Document uploaded" }
        format.json { render :show, status: :created, location: @claim_benefit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @claim_attachment.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def destroy
    @claim_attachment.destroy

    respond_to do |format|
      format.html { redirect_to show_coop_process_claim_path(@process_claim), notice: "Document removed" }
      format.json { head :no_content }
    end
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_claim_attachment
    @claim_attachment = ClaimAttachment.find(params[:id])
    @process_claim = @claim_attachment.process_claim
  end

  # Only allow a list of trusted parameters through.
  def claim_attachment_params
    params.require(:claim_attachment).permit(:process_claim_id, :claim_type_document_id, :doc )
  end
end
