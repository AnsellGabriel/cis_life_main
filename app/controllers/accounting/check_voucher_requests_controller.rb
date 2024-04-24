class Accounting::CheckVoucherRequestsController < ApplicationController
  def index
    # Your code here
  end

  def show
    if params[:pt] == "check_voucher"
      @requests = Accounting::CheckVoucherRequest.find(params[:id]).check_vouchers.order(created_at: :desc)
    elsif params[:pt] == "debit_advice"
      @requests = Accounting::CheckVoucherRequest.find(params[:id]).debit_advices.order(created_at: :desc)
    end

    @pagy, @check_vouchers = pagy(@requests, items: 10)
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
