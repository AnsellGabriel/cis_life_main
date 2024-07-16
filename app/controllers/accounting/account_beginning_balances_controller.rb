class Accounting::AccountBeginningBalancesController < ApplicationController
  before_action :set_accounting_account_beginning_balance, only: %i[ show edit update destroy ]

  # GET /accounting/account_beginning_balances
  def index
    @accounting_account_beginning_balances = Accounting::AccountBeginningBalance.all
  end

  # GET /accounting/account_beginning_balances/1
  def show
  end

  # GET /accounting/account_beginning_balances/new
  def new
    @accounting_account_beginning_balance = Accounting::AccountBeginningBalance.new
  end

  # GET /accounting/account_beginning_balances/1/edit
  def edit
  end

  # POST /accounting/account_beginning_balances
  def create
    @accounting_account_beginning_balance = Accounting::AccountBeginningBalance.new(accounting_account_beginning_balance_params)

    if @accounting_account_beginning_balance.save
      redirect_to @accounting_account_beginning_balance, notice: "Account beginning balance was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounting/account_beginning_balances/1
  def update
    if @accounting_account_beginning_balance.update(accounting_account_beginning_balance_params)
      redirect_to @accounting_account_beginning_balance, notice: "Account beginning balance was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounting/account_beginning_balances/1
  def destroy
    @accounting_account_beginning_balance.destroy
    redirect_to accounting_account_beginning_balances_url, notice: "Account beginning balance was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accounting_account_beginning_balance
      @accounting_account_beginning_balance = Accounting::AccountBeginningBalance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def accounting_account_beginning_balance_params
      params.require(:accounting_account_beginning_balance).permit(:account_id, :balance, :year)
    end
end
