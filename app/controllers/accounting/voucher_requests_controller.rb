class Accounting::VoucherRequestsController < ApplicationController
  before_action :set_request, only: %i[show reject]

  def index
    # binding.pry
    @requests = Accounting::VoucherRequest.where(payment_type: params[:pt].to_sym).order(created_at: :desc)
    @requests = @requests.where(status: params[:status]) if params[:status].present?

    if params[:date_from].present? && params[:date_to].present?
      @requests = @requests.where(created_at: params[:date_from].to_date.beginning_of_day..params[:date_to].to_date.end_of_day)
    end

    # if params[:date_from].present? && params[:date_to].present?
    #   @requests = Accounting::VoucherRequest.where(created_at: params[:date_from].to_date.beginning_of_day..params[:date_to].to_date.end_of_day, payment_type: params[:pt].to_sym).order(created_at: :desc)
    # else
    #   @requests = Accounting::VoucherRequest.where(payment_type: params[:pt].to_sym).order(created_at: :desc)
    # end

    @pagy, @requests = pagy(@requests, items: 10)
  end

  def show
    @request = Accounting::VoucherRequest.find(params[:id])
    @claim_type_documents = Claims::ClaimTypeDocument.where(claim_type: @request.requestable.try(:claim_type))
    @receipt = Accounting::DebitAdviceReceipt.find_by(debit_advice_id: @request.requestable.id)
    @vouchers = @request.vouchers
    @pagy, @vouchers = pagy(@vouchers, items: 10)
  end

  private

  def set_request
    @request = Accounting::VoucherRequest.find(params[:id])
  end
end
