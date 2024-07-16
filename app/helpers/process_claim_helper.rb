module ProcessClaimHelper
    def claim_route_row(label, route_id)

        content_tag :tr do

          concat content_tag(:td, label)
          concat content_tag(:td, class: 'text-center') { link_to @process_claims.where(claim_route: route_id).count, index_show_claims_process_claims_path(p: route_id) }
        end
    end

    def get_route_evaluators
        case @claims_user_authority_level.name
        when "Claims Evaluator"
            return 4
        when "COSO (Approver)"
            return 5
        when "President (Approver)"
            return 6
        else
            return 3
        end
    end

    def validate_evaluator(process_claim)
        case @claims_user_authority_level.name
        when "Claims Evaluator"
            return true if process_claim.claim_route == "evaluation"
        when "COSO (Approver)"
            return true if process_claim.claim_route == "evaluation_coso"
        when "President (Approver)"
            return true if process_claim.claim_route == "evaluation_president"
        else
            return true if process_claim.claim_route == "claim_review"
        end
        return false
    end

    def get_date_tat(start_date, end_date)
        start_time = DateTime.parse(start_date.to_s)
        end_time = DateTime.parse(end_date.to_s)
        # total_seconds = end_time - start_time
        # current_time = start_time
        # workdays_seconds = d
        seconds_difference = (start_time.to_time - end_time.to_time).to_i

        # while current_time < end_time
        #     unless current_time.saturday? || current_time.sunday?
        #         # Calculate the end of the current day
        #         day_end = current_time.end_of_day
        #         if day_end > end_time
        #             day_end = end_time
        #         end
        #         # Add the number of seconds for the current day
        #         workdays_seconds += (day_end - current_time)
        #     end
        #     # Move to the beginning of the next day
        #     current_time = (current_time + 1.day).beginning_of_day
        #     raise "errors"
        # end
        days = (seconds_difference / 1.day).to_i
        hours = ((seconds_difference % 1.day) / 1.hour).to_i
        return "#{days} days, #{hours} hours"
        # workdays = (workdays_seconds / 1.day).to_i
        # workhours = ((workdays_seconds % 1.day) / 1.hour).to_i
        # return "#{workdays} days, #{workhours} hours"
    end

    def approver_routes(process_claim, max_amount, status)
        path = 0

        case status
        when "approved"
            path = 23
        when "denied"
            path = 9
        when "pending"
            path = 25
        when "reconsider"
            path = 5
        end
        case process_claim.claim_route
        # when process_claim.claim_review?
        when "claim_review"
            unless process_claim.check_authority_level(max_amount)
                path = 4
            end
        when "evaluation"
            # raise "errors"
            if @claims_user_authority_level.name == "Claims Evaluator"
                unless process_claim.check_authority_level(max_amount)
                    path = 5
                end
            end
        when "evaluation_coso"
            if @claims_user_authority_level.name == "COSO (Approver)"
                unless process_claim.check_authority_level(max_amount)
                    path = 6
                end
            end
        # when "evaluation_president"
        #     if @claims_user_authority_level.name == "President (Approver)"

        #     end

        when "reconsider_review"
            unless @claims_user_reconsider.nil?
                if @claims_user_reconsider.name == "Claims Head (Reconsider)"
                    unless process_claim.check_authority_level(@claims_user_reconsider.maxAmount)
                        path = 20
                    end
                end
            end

        when "reconsider_coso"
            unless @claims_user_reconsider.nil?
                if @claims_user_reconsider.name == "COSO (Reconsider)"
                    unless process_claim.check_authority_level(@claims_user_reconsider.maxAmount)
                        path = 6
                    end
                end
            end
        end
        # raise "errors"
        return path
    end
end
