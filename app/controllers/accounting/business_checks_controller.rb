class Accounting::BusinessChecksController < ApplicationController
  before_action :set_check, only: %i[ show edit update destroy ]
  # before_action :cache_voucher_id, only: %i[ new ]
  before_action :set_voucher_and_checks, only: %i[ new create edit update destroy]

  def index
    if params[:check_number].present?
      @checks = Treasury::BusinessCheck.where(check_number: params[:check_number])
    else
      @checks = Treasury::BusinessCheck.all.order(created_at: :desc)
    end

    @pagy, @checks = pagy(@checks, items: 10)
  end

  def show

  end

  def search
    search_voucher

    if @voucher
      redirect_to accounting_check_path(@voucher)
    else
     redirect_to accounting_business_check_index_path, alert: "Check voucher not found"
    end
  end

  def new
    @check = @business_checks.build(amount: @voucher.amount)
  end

  def edit
  end

  def create
    @check = @business_checks.build(check_params)

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

  def search_voucher
    @voucher = Accounting::Check.find_by(voucher: params[:voucher])
  end

  # Only allow a list of trusted parameters through.
  def check_params
    params.require(:treasury_business_check).permit(:check_number, :check_date, :amount, :check_type)
  end
end
