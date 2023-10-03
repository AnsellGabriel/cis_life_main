module CoverageStatus
	extend ActiveSupport::Concern

  included do
    def update_batch_and_existing_coverage(batch, existing_coverages, group_remit)
      coverage_expiry = existing_coverages.expiry
      today = Date.today

      month_difference = ((today.year * 12 + today.month) - (coverage_expiry.year * 12 + coverage_expiry.month)) + (coverage_expiry.day > today.day ? 1 : 0)

      if month_difference > 24
        batch.status = :reinstated
        existing_coverages.update!(
          status: 'reinstated',
          expiry: batch.expiry_date,
          effectivity: batch.effectivity_date
        )
      elsif batch.class.name == 'LoanInsurance::Batch'
        batch.status = :reloan
        existing_coverages.update!(
          status: 'reloan',
          expiry: batch.expiry_date,
          effectivity: batch.effectivity_date
        )
      # elsif existing_coverages.expiry <= Date.today
      #   batch.status = :renewal
      #   existing_coverages.update!(
      #     status: 'renewal',
      #     expiry: batch.expiry_date,
      #     effectivity: batch.effectivity_date
      #   )
      end
    end

    def create_new_batch_coverage(agreement, coop_member, batch )
      if agreement.transferred_date.present? && (agreement.transferred_date >= coop_member.membership_date)
        batch.status = :transferred
      else
        batch.status = :recent
      end

      agreement.agreements_coop_members.create!(
        coop_member_id: coop_member.id,
        status: 'new',
        expiry: batch.expiry_date,
        effectivity: batch.effectivity_date
      )
    end
  end
end
