
class Claims::ClaimDocumentsController < ApplicationController
    before_action :set_document, only: %i[ show edit update destroy document_request ]
    
    
    
    def index 
        @claim_documents = Claims::ClaimDocument.all
    end

    def show 
    end

    def new 
        @claim_document = Claims::ClaimDocument.new
    end
    
    def create 
        @claim_document = Claims::ClaimDocument.new(claim_document_params)

        if @claim_document.save
            redirect_to claims_claim_documents_url, notice: "Document was successfully created."
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit 

    end

    def update 
        if @claim_document.update(claim_document_params)
            redirect_to claims_claim_documents_url, notice: "Document was successfully updated."
          else
            render :edit, status: :unprocessable_entity
          end
    end

    def destroy 
        @claim_document.destroy
        redirect_to claims_claim_documents_url, notice: "Document was successfully destroyed.", status: :see_other
    end

    private
  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @claim_document = Claims::ClaimDocument.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def claim_document_params
    params.require(:claims_claim_document).permit(:name, :description)
  end
end
