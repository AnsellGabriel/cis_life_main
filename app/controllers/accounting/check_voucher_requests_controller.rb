class Accounting::CheckVoucherRequestsController < ApplicationController
  def index
    # Your code here
  end

  def show
    @checks = Accounting::CheckVoucherRequest.find(params[:id]).check_vouchers.order(created_at: :desc)
    @pagy, @check_vouchers = pagy(@checks, items: 10)
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
