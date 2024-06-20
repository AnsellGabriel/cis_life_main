
class Claims::ClaimTypeDocumentsController < ApplicationController
  before_action :set_claim_type_document, only: %i[ edit update destroy document_request ]


  def document_request 
    @process_claim = Claims::ProcessClaim.find(params[:p])
    @claim_document_request = Claims::ClaimDocumentRequest.find_by(process_claim: @process_claim, claim_type_document: @claim_type_document)
    unless @claim_document_request.present?
      @claim_document_request = @claim_type_document.claim_document_requests.build(process_claim_id: @process_claim.id)
      if @claim_document_request.save! 
        redirect_to claim_process_claims_process_claim_path(@process_claim), notice: "Document was successfully requested."
      else
        redirect_to claim_process_claims_process_claim_path(@process_claim), notice: "Document was not successfully requested."
      end
    else
      @claim_document_request.destroy 
      redirect_to claim_process_claims_process_claim_path(@process_claim), notice: "Document is not requested."
    end
  end 

  def new
    @claim_type = Claims::ClaimType.find(params[:p])
    @claim_type_document = @claim_type.claim_type_documents.build
  end

  def create
    @claim_type = Claims::ClaimType.find(params[:p])
    @claim_type_document = @claim_type.claim_type_documents.build(claim_type_document_params)
    # @claim_benefit = ClaimBenefit.new(claim_benefit_params)
    respond_to do |format|
      if @claim_type_document.save
        format.html { redirect_to claims_claim_type_path(@claim_type), notice: "Document was successfully added." }
        # format.json { render :show, status: :created, location: @claim_type_document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @claim_type_document.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @claim_type_document.update(claim_type_document_params)
        format.html { redirect_to claims_claim_type_path(@claim_type), notice: "Document was successfully updated." }
        format.json { render :show, status: :ok, location: @claim_benefit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @claim_type.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @claim_type_document.destroy

    respond_to do |format|
      format.html { redirect_to claims_claim_type_path(@claim_type), notice: "Claim benefit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_claim_type_document
    @claim_type_document = Claims::ClaimTypeDocument.find(params[:id])
    @claim_type = @claim_type_document.claim_type
  end

  # Only allow a list of trusted parameters through.
  def claim_type_document_params
    params.require(:claims_claim_type_document).permit(:claim_type_id, :claim_document_id, :required, :name, 
                  claim_document_request_attributes: [:process_claim_id])
  end
end
