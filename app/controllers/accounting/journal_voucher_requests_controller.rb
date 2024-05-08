class Accounting::JournalVoucherRequestsController < ApplicationController
  def show
    @request = Accounting::JournalVoucherRequest.find(params[:id])
    @receipt = Accounting::DebitAdviceReceipt.find_by(debit_advice_id: @request.requestable.id)

    if params[:pt] == "debit_advice"
      @requests = Accounting::JournalVouchers
    end

    @pagy, @requests = pagy(@requests, items: 10)
  end
end
