class Accounting::CheckVouchersController < ApplicationController
  before_action :set_accounting_check_voucher, only: %i[ show edit update destroy ]

  # GET /accounting/check_vouchers
  def index
    @accounting_check_vouchers = Accounting::CheckVoucher.all
  end

  # GET /accounting/check_vouchers/1
  def show
  end

  # GET /accounting/check_vouchers/new
  def new
    @accounting_check_voucher = Accounting::CheckVoucher.new
  end

  # GET /accounting/check_vouchers/1/edit
  def edit
  end

  # POST /accounting/check_vouchers
  def create
    @accounting_check_voucher = Accounting::CheckVoucher.new(accounting_check_voucher_params)

    if @accounting_check_voucher.save
      redirect_to @accounting_check_voucher, notice: "Check voucher was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounting/check_vouchers/1
  def update
    if @accounting_check_voucher.update(accounting_check_voucher_params)
      redirect_to @accounting_check_voucher, notice: "Check voucher was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounting/check_vouchers/1
  def destroy
    @accounting_check_voucher.destroy
    redirect_to accounting_check_vouchers_url, notice: "Check voucher was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accounting_check_voucher
      @accounting_check_voucher = Accounting::CheckVoucher.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def accounting_check_voucher_params
      params.require(:accounting_check_voucher).permit(:date_voucher, :voucher, :payable_id, :payable_type, :address, :amount, :particulars)
    end
end
