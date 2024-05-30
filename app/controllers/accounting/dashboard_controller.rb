class Accounting::DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    request = Accounting::VoucherRequest.where(status: :pending)
    @for_approvals = Accounting::Check.where(status: :for_approval).order(created_at: :desc)
    @check_req =request.where(payment_type: :check_voucher).order(created_at: :desc)
    @da_req =request.where(payment_type: :debit_advice).order(created_at: :desc)
    @journal_req =request.where(payment_type: :journal_voucher).order(created_at: :desc)
  end
end
