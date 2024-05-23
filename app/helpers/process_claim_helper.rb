module ProcessClaimHelper
    def approver_routes(process_claim, max_amount) 
        path = 0
        # raise "errors"
        case process_claim.claim_route
        # when process_claim.claim_review? 
        when "claim_review"
            if process_claim.check_authority_level(max_amount)
                path = 7
            else
                path = 4
            end
        when "evaluation"
            # raise "errors"
            if @claims_user_authority_level.name == "Evaluators"
                if process_claim.check_authority_level(max_amount)
                    path = 7
                else
                    path = 5
                end
            end
        when "evaluation_coso"
            if @claims_user_authority_level.name == "COSO Evaluator"
                if process_claim.check_authority_level(max_amount)
                    path = 7
                else
                    path = 6
                end
            end 
        when "evaluation_president"
            if @claims_user_authority_level.name == "President Evaluator"
                path = 7
            end
        end
        # raise "errors"
        return path
    end
end
