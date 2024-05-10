class Accounting::VoucherRequestsController < ApplicationController
  def index
    @requests = Accounting::VoucherRequest.where(payment_type: params[:pt].to_sym).order(created_at: :desc)
    @pagy, @requests = pagy(@requests, items: 10)
  end

  def show
    @request = Accounting::VoucherRequest.find(params[:id])
    @claim_type_documents = Claims::ClaimTypeDocument.where(claim_type: @request.requestable.try(:claim_type))
    @receipt = Accounting::DebitAdviceReceipt.find_by(debit_advice_id: @request.requestable.id)
    @vouchers = @request.vouchers
    @pagy, @vouchers = pagy(@vouchers, items: 10)
  end
end
