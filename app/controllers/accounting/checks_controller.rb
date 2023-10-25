class Accounting::ChecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_check, only: %i[ show edit update destroy ]
  before_action :set_payables, only: %i[ new edit create update]

  # GET /accounting/checks
  def index
    @checks = Accounting::Voucher.where(type: 'Accounting::Check')
  end

  # GET /accounting/checks/1
  def show
  end

  # GET /accounting/checks/new
  def new
    last_voucher = Accounting::Check.maximum(:voucher)
    initiate_voucher = last_voucher ? last_voucher + 1 : 0

    @check = Accounting::Check.new(voucher: initiate_voucher)
  end

  # GET /accounting/checks/1/edit
  def edit

  end

  # POST /accounting/checks
  def create
    @check = Accounting::Check.new(modified_check_params)
    @check.amount = check_params[:amount].to_f

    if @check.save
      redirect_to @check, notice: "Check was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounting/checks/1
  def update
    if @check.update(modified_check_params)
      redirect_to @check, notice: "Check was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounting/checks/1
  def destroy
    @check.destroy
    redirect_to accounting_checks_path, notice: "Check was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_check
    @check = Accounting::Check.find(params[:id])
  end

  # collection of payees
  def set_payables
    @payables = Cooperative.all
  end

  # Only allow a list of trusted parameters through.
  def check_params
    params.require(:accounting_check).permit(:date_voucher, :voucher, :global_payable, :particulars, :treasury_account_id, :amount)
  end

  # convert the string amount to float
  def modified_check_params
    check_params[:amount] = check_params[:amount].to_f
    check_params
  end

end
