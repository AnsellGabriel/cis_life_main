class Accounting::JournalVoucherRequestsController < ApplicationController
  def show
    @request = Accounting::JournalVoucherRequest.find(params[:id])
    @receipt = Accounting::DebitAdviceReceipt.find_by(debit_advice_id: @jv_request.requestable.id)
    @vouchers = @request.vouchers
    @pagy, @jvs = pagy(@jvs, items: 10)
  end
end
