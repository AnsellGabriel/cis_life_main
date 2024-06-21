class Claims::ClaimCoverageReinsurancesController < ApplicationController
    before_action :set_claim_reinsurance, only: %i[ show claim_reinsurance_update ]
    before_action :set_claim_coverage_reinsurance, only: %i[ edit update destroy ]

    def claim_reinsurance_create
        @process_claim = Claims::ProcessClaim.find(params[:p])
        @claim_reinsurance = Claims::ClaimReinsurance.find_or_initialize_by(process_claim: @process_claim)
        @claim_reinsurance.status = :pending
       
        if @claim_reinsurance.save()
            # @process_claim.process_track.create(route_id: 26, user_id: current_user.id)
            return redirect_to claim_process_claims_process_claim_path(@process_claim), notice: "Reinsurance Process Submitted"
        end 
    end

    def claim_reinsurance_update
        if @claim_reinsurance.status == "pending"
            status = "accomplished"
        else
            status = "pending"
        end
        # raise "errors"
        if @claim_reinsurance.update(status: status)
            # @process_claim.process_track.create(route_id: 27, user_id: current_user.id) if status == "accomplished"
            return redirect_to claims_claim_coverage_reinsurance_path(@claim_reinsurance), notice: "Claims Reinsurance Accomplished" if status == "accomplished"
            return redirect_to claims_claim_coverage_reinsurance_path(@claim_reinsurance), alert: "Claims Reinsurance Pending" if status == "pending"
        end
    end

    def index 
        @claim_reinsurances = Claims::ClaimReinsurance.all
    end

    def show 
    end

    def new 
        @claim_coverage = Claims::ClaimCoverage.find(params[:c])
        @claim_reinsurance = Claims::ClaimReinsurance.find(params[:r])
        @claim_coverage_reinsurance = @claim_reinsurance.claim_coverage_reinsurances.build
        @claim_coverage_reinsurance.claim_coverage = @claim_coverage
    end

    def create
        @claim_reinsurance = Claims::ClaimReinsurance.find(params[:r])
        @claim_coverage_reinsurance = @claim_reinsurance.claim_coverage_reinsurances.build(coverage_reinsurance_params)
        respond_to do |format|
            if @claim_coverage_reinsurance.save!
                return redirect_to claims_claim_coverage_reinsurance_path(@claim_reinsurance), notice: "Reinsurance Coverage Updated"
            else
                format.html { render :new, status: :unprocessable_entity }
                format.turbo_stream { render :form_update, status: :unprocessable_entity }
            end
        end
    end

    def edit 
    end

    def update 
        respond_to do |format|
            if @claim_coverage_reinsurance.update(coverage_reinsurance_params)
                return redirect_to claims_claim_coverage_reinsurance_path(@claim_reinsurance), notice: "Reinsurance Coverage Updated"
            else
                format.html { render :edit, status: :unprocessable_entity }
                format.turbo_stream { render :form_update, status: :unprocessable_entity }
            end
        end
    end

    def destroy 
        @claim_coverage_reinsurance.destroy
        return redirect_to claims_claim_coverage_reinsurance_path(@claim_reinsurance), alert: "Reinsurance removed"
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_claim_coverage_reinsurance
        @claim_coverage_reinsurance = Claims::ClaimCoverageReinsurance.find(params[:id])
        @claim_reinsurance = @claim_coverage_reinsurance.claim_reinsurance
        # @process_claim = @claim_remark.process_claim
    end

    def set_claim_reinsurance 
        @claim_reinsurance = Claims::ClaimReinsurance.find(params[:id])
        @process_claim = @claim_reinsurance.process_claim
        @coverage_reinsurances = Claims::ClaimCoverageReinsurance.where(claim_reinsurance: @claim_reinsurance)
        @reinsurers = Reinsurer.all
    end

    # Only allow a list of trusted parameters through.
    def coverage_reinsurance_params
        params.require(:claims_claim_coverage_reinsurance).permit(:claim_reinsurance_id, :claim_coverage_id, :reinsurer_id, :amount, :ri_reported)
    end
    def claim_reinsurance_params
        params.require(:claims_claim_reinsurance).permit(:process_claim_id, :status)
    end

end
