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
    @cooperatives = Cooperative.all
  end

  # GET /accounting/check_vouchers/1/edit
  def edit
  end

  # POST /accounting/check_vouchers
  def create
    params[:accounting_check_voucher][:amount] = params[:accounting_check_voucher][:amount].gsub(',', '').to_d

    @accounting_check_voucher = Accounting::CheckVoucher.new(accounting_check_voucher_params.reject { |key, value| key == "payable" })
    @cooperatives = Cooperative.all

    unless accounting_check_voucher_params[:payable].empty?
      parsed_payable = JSON.parse(accounting_check_voucher_params[:payable])
      payable = parsed_payable[1].constantize.find(parsed_payable[0])
    end

    @accounting_check_voucher.payable = payable

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
      params.require(:accounting_check_voucher).permit(:date_voucher, :voucher, :payable, :amount, :particulars)
    end
end
