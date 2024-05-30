class Accounting::DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    for_approvals
    request = Accounting::VoucherRequest.where(status: :pending)
    @check_req =request.where(payment_type: :check_voucher).order(created_at: :desc)
    @da_req =request.where(payment_type: :debit_advice).order(created_at: :desc)
    @journal_req =request.where(payment_type: :journal_voucher).order(created_at: :desc)
  end

  def for_approval
    for_approvals
  end

  private

  def for_approvals
    check_for_approval = Accounting::Check.where(status: :for_approval)
    da_for_approval = Accounting::DebitAdvice.where(status: :for_approval)
    journal_for_approval = Accounting::Journal.where(status: :for_approval)
    @for_approvals = (check_for_approval + da_for_approval + journal_for_approval).sort_by(&:created_at)
  end
end
