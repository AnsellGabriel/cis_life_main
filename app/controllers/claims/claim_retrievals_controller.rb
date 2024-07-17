class Claims::ClaimRetrievalsController < ApplicationController
    before_action :set_claim_retrieval, only: %i[ show edit update destroy ]

    def index 
        @claim_retrievals = Claims::ClaimRetrieval.all
    end

    def new
        @claim_retrieval = Claims::ClaimRetrieval.new
    end
    
    def edit
    end

    def show 
    end

    def create 
        @claim_retrieval = Claims::ClaimRetrieval.new(claim_retrieval_params)

        if @claim_retrieval.save!
        redirect_to claims_claim_retrievals_path, notice: "Retrieval was successfully created."
        else
        render :new, status: :unprocessable_entity
        end
    end

    def update 
        if @claim_retrieval.update(claim_retrieval_params)
            redirect_to claims_claim_retrievals_path, notice: "Retrieval was updated.", status: :see_other
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @claim_retrieval.destroy
        # redirect_to claims_claim_retrievals_path, notice: "Retrieval was destroyed."
        redirect_to claims_claim_retrievals_path, alert: "Claims fund account was deactived.", status: :see_other
    end
    

    private
        def set_claim_retrieval
            @claim_retrieval = Claims::ClaimRetrieval.find(params[:id])
        end
        def claim_retrieval_params
            params.require(:claims_claim_retrieval).permit(:name, :description)
        end
end
