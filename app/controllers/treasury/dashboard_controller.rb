class Treasury::DashboardController < ApplicationController
  def index
    @for_approvals = Treasury::CashierEntry.where(status: :for_approval)
    @for_ors = Payment.where(status: :for_review)
    @vouchers = Accounting::Check.where(status: :posted, claimable: false, audit: :approved)
    @debit_advices = Accounting::DebitAdvice.approved.pending_payout
  end

  def for_approval
    @for_approvals = Treasury::CashierEntry.where(status: :for_approval).order(created_at: :desc)
  end
end
