class Accounting::BusinessChecksController < ApplicationController
  before_action :set_check, only: %i[ show edit update destroy ]
  before_action :set_voucher_and_checks, only: %i[ new create edit update destroy]

  def show
  end

  def new
    last_check_no = @business_checks.maximum(:check_number)
    initiate_check_no = last_check_no ? last_check_no + 1 : 1
    @check = @business_checks.build(amount: @voucher.amount, check_date: Date.today, check_number: initiate_check_no, check_type: :regular)
  end

  def edit
  end

  def create
    @check = @business_checks.build(check_params)
    @total_amount = @business_checks.sum(:amount) + @check.amount

    if @total_amount > @voucher.amount
      return redirect_to accounting_check_path(@voucher), alert: "Business check denied. Total amount of business checks is greater than the voucher amount."
    end

    if @check.save
      redirect_to accounting_check_path(@voucher), notice: "Business check added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @check.update(check_params)
      redirect_to accounting_check_path(@voucher), notice: "Business check updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @check.destroy
      redirect_to accounting_check_path(@voucher), alert: "Business check deleted.", status: :see_other
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_check
    @check = Treasury::BusinessCheck.find(params[:id])
  end

  def set_voucher_and_checks
    @voucher = Accounting::Check.find(params[:check_id])
    @business_checks = @voucher.business_checks
  end

  # Only allow a list of trusted parameters through.
  def check_params
    params.require(:treasury_business_check).permit(:check_number, :check_date, :amount, :check_type)
  end
end
