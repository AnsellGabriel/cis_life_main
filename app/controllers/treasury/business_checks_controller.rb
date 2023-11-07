class Treasury::BusinessChecksController < ApplicationController
  before_action :set_check, only: %i[ show edit update destroy ]
  before_action :cache_voucher_id, only: %i[ new ]
  before_action :set_voucher, only: %i[ new create]

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

  def new
    unless @voucher
      return redirect_to treasury_business_checks_path, alert: "Check voucher not found"
    end

    set_checks

    @check = @voucher.business_checks.build(amount: @voucher.amount)
  end

  def edit
  end

  def create
    set_checks
    @check = @voucher.business_checks.build(check_params)

    if @check.save
      redirect_to new_treasury_business_check_path(voucher: @check.voucher.voucher), notice: "Business check was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @check.update(check_params)
      redirect_to new_treasury_business_check_path(voucher: @check.voucher.voucher), notice: "Business check was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @check.destroy
      redirect_to new_treasury_business_check_path(voucher: @check.voucher.voucher), notice: "Business check was successfully deleted.", status: :see_other
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_check
    @check = Treasury::BusinessCheck.find(params[:id])
  end

  def cache_voucher_id
    session[:check_voucher] = params[:voucher] # store the check_voucher number in the session for later purposes
  end

  def set_voucher
    @voucher = Accounting::Check.find_by(voucher: session[:check_voucher])
    # fetch all business checks except the one that is already associated with the voucher
  end

  def set_checks
    @business_checks = @voucher.business_checks.where.not(id: nil).order(created_at: :desc)
  end

  # Only allow a list of trusted parameters through.
  def check_params
    params.require(:treasury_business_check).permit(:check_number, :check_date, :amount, :check_type)
  end
end
