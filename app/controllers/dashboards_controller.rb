class DashboardsController < ApplicationController
    include ProcessClaimHelper

    def actuarial
        @claim_reinsurance = Claims::ClaimReinsurance.where(status: 0)
        render :index
    end

    def claims
        @user_levels = current_user.user_levels.where(active: 1) if current_user
        @for_evaluation = Claims::ProcessClaim.where(claim_route: get_route_evaluators) if current_user.userable_type == "Employee" 
        # unless @claims_user_authority_level == "Claims Evaluator" ||  @claims_user_authority_level == "COSO (Approver)" || @claims_user_authority_level == "President (Approver)"
        #   @for_evaluation = Claims::ProcessClaim.where(claim_route: 3)
        # end
        @coop_messages = Claims::ClaimRemark.where(coop: 1)
        @process_claims = Claims::ProcessClaim.all
        @claim_reinsurances = Claims::ClaimReinsurance.all
        render :index
    end
end
