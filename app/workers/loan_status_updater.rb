require 'sidekiq-scheduler'

class LoanStatusUpdater
	include Sidekiq::Job

  def perform
    expired_loans = LoanInsurance::Batch.where(insurance_status: :approved)
      .where.not(status: :expired)
      .where("expiry_date <= ?", Date.current).includes(coop_member: :member)

    expired_loans.each do |loan|
      member = loan.coop_member.member

      loan.update!(status: :expired)
      member.update!(total_loan_amount: member.total_loan_amount - loan.loan_amount)
      member.update!(for_reinsurance: false) if member.total_loan_amount < 550_000
    end
  end

end
