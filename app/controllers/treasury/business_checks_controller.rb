class Treasury::BusinessChecksController < ApplicationController
  def index
    if params[:check_number].present?
      @checks = Treasury::BusinessCheck.where(check_number: params[:check_number])
    else
      @checks = Treasury::BusinessCheck.all.order(created_at: :desc)
    end

    @pagy, @checks = pagy(@checks, items: 10)
  end

  def requests
    @vouchers = Accounting::Check.where(status: :posted, claimable: false, audit: :approved).order(created_at: :desc)

    @pagy, @vouchers = pagy(@vouchers, items: 10)
  end

  def search
    search_voucher

    if @voucher
      redirect_to accounting_check_path(@voucher)
    else
     redirect_to treasury_checks_path, alert: "Check voucher not found"
    end
  end

  private

  def search_voucher
    @voucher = Accounting::Check.find_by(voucher: params[:voucher], status: :posted)
  end
end
