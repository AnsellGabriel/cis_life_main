class Treasury::AccountsController < ApplicationController
  include CsvGenerator
  include ActionView::Helpers::NumberHelper

  before_action :set_treasury_account, only: %i[ show edit update destroy ]


  # GET /treasury/accounts
  def index
    @q = Treasury::Account.ransack(params[:q])
    @treasury_accounts = @q.result(distinct: true)
  end

  # GET /treasury/accounts/1
  def show
    # date range for ledger search
    if params[:date_from].present? && params[:date_to].present?
      search_date = params[:date_from]&.to_date..params[:date_to]&.to_date
    end
    # date range for computing ledger current balance
    balance_date = DateTime.new(Date.today.year, 1, 1)..params[:date_to]&.to_date
    ledgers = @treasury_account.general_ledgers.where(transaction_date: balance_date)

    @searched_ledgers = ledgers.where(transaction_date: search_date)
    @pagy, @view_ledger = pagy(@searched_ledgers, items: 20)
    # sum of all debits and credits before the first ledger entry
    initial_debit = ledgers.debits.where("id < ?", @view_ledger.first&.id).sum(:amount)
    initial_credit = ledgers.credits.where("id < ?", @view_ledger.first&.id).sum(:amount)

    @prev_day_balance = @treasury_account.general_ledgers.where(transaction_date: DateTime.new(Date.today.year, 1, 1)..params[:date_from]&.to_date.prev_day).sum(:amount)
    @initial_balance = initial_debit - initial_credit
    @total_debit = @searched_ledgers.debits.sum(:amount)
    @total_credit = @searched_ledgers.credits.sum(:amount)

    respond_to do |format|
      format.html
      format.csv {
        generate_csv(@searched_ledgers, "#{@treasury_account.name.downcase}_ledger_#{params[:date_from]}_to_#{params[:date_to]}", @prev_day_balance)
      }
    end
  end

  # GET /treasury/accounts/new
  def new
    @treasury_account = Treasury::Account.new
  end

  # GET /treasury/accounts/1/edit
  def edit
  end

  # POST /treasury/accounts
  def create
    @treasury_account = Treasury::Account.new(treasury_account_params)

    if @treasury_account.save
      redirect_to @treasury_account, notice: "Account was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /treasury/accounts/1
  def update
    if @treasury_account.update(treasury_account_params)
      redirect_to @treasury_account, notice: "Account was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /treasury/accounts/1
  def destroy
    @treasury_account.destroy
    redirect_to treasury_accounts_url, notice: "Account was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_treasury_account
    @treasury_account = Treasury::Account.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def treasury_account_params
    params.require(:treasury_account).permit(:name, :account_type, :is_check_account, :contact_number, :address)
  end
end
