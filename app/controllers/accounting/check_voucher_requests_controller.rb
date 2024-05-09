class Accounting::CheckVoucherRequestsController < ApplicationController
  def index
    # Your code here
  end

  def show
    @request = Accounting::CheckVoucherRequest.find(params[:id])
    @claim_type_documents = ClaimTypeDocument.where(claim_type: @request.requestable.claim_type)
    @vouchers = @request.vouchers
    @pagy, @vouchers = pagy(@vouchers, items: 10)
  end

  def new
    # Your code here
  end

  def create
    # Your code here
  end

  def edit
    # Your code here
  end

  def update
    # Your code here
  end

  def destroy
    # Your code here
  end
end
