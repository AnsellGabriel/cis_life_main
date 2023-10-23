class Accounting::VouchersController < ApplicationController
  before_action :set_accounting_voucher, only: %i[ show edit update destroy ]

  # GET /accounting/vouchers
  def index
    @accounting_vouchers = Accounting::Voucher.all
  end

  # GET /accounting/vouchers/1
  def show
  end

  # GET /accounting/vouchers/new
  def new
    @accounting_voucher = Accounting::Voucher.new
  end

  # GET /accounting/vouchers/1/edit
  def edit
  end

  # POST /accounting/vouchers
  def create
    @accounting_voucher = Accounting::Voucher.new(accounting_voucher_params)

    if @accounting_voucher.save
      redirect_to @accounting_voucher, notice: "Voucher was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounting/vouchers/1
  def update
    if @accounting_voucher.update(accounting_voucher_params)
      redirect_to @accounting_voucher, notice: "Voucher was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounting/vouchers/1
  def destroy
    @accounting_voucher.destroy
    redirect_to accounting_vouchers_url, notice: "Voucher was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accounting_voucher
      @accounting_voucher = Accounting::Voucher.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def accounting_voucher_params
      params.require(:accounting_voucher).permit(:date_voucher, :voucher, :payable_id, :payable_type, :treasury_account_id, :amount, :particulars)
    end
end
