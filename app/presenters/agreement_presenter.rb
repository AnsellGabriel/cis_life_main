class AgreementPresenter
    include DateHelper
    include Rails.application.routes.url_helpers

    def initialize(agreement)
		@agreement = agreement
	end

    def group_remits_submitted?
        @agreement.active_group_remits.present? || @agreement.expired_group_remits.present? || @agreement.renewed_group_remits.present?
    end

    def batch_remit_batches_count
        @agreement.group_remits.batch_remits.joins(:batches).size
    end

    def anniversary_dates
        dates = @agreement.anniversaries.map {|anniv| date_as_month_day(anniv.anniversary_date)}
        combined_dates = dates.join(', ')
    end

    def plan_acronym
        case @agreement.plan.acronym
        when 'GYRT', 'GYRTF', 'GYRTBR', 'GYRTFR' then 'GYRT'
        else @agreement.plan.acronym
        end
    end

    def insurance_path
        case @agreement.plan.acronym
        when 'GYRT', 'GYRTF', 'GYRTBR', 'GYRTFR' then coop_agreement_path(@agreement)
        when 'LPPI' then loan_insurance_group_remits_path
        end
    end
end