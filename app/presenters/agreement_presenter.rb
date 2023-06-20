class AgreementPresenter
    def initialize(agreement)
		@agreement = agreement
	end

    def group_remits_submitted?
        @agreement.active_group_remits.present? || @agreement.expired_group_remits.present? || @agreement.renewed_group_remits.present?
    end
end