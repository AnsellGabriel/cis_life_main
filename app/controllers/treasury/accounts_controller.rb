class Treasury::AccountsController < ApplicationController
  include Treasuries::Ledgerable
  include CsvGenerator
  include ActionView::Helpers::NumberHelper

  before_action :set_treasury_account, only: %i[ show edit update destroy ]


  # GET /treasury/accounts
  def index
    @q = Treasury::Account.ransack(params[:q])
    @treasury_accounts = @q.result(distinct: true)
  end

  def show_report
    @report_name = current_user.userable.report.identifier
  end

  def show_pdf
    @account = Treasury::Account.find(params[:account_id])
    # concerns/treasuries/ledgerable.rb
    set_dates
    set_ledger_and_pagy
    compute_balance

    respond_to do |format|
      format.pdf do
        render pdf: "Check voucher",
               page_size: "A4"
      end
    end
  end

  # GET /treasury/accounts/1
  def show
    # concerns/treasuries/ledgerable.rb
    set_dates
    set_ledger_and_pagy
    compute_balance

    if params[:download_csv] == 'true'
      @account.general_ledgers.to_csv(current_user.userable.id, @account.id, params[:date_from], params[:date_to])
      flash.now[:notice] = "CSV will be generated and will be ready for download once done"
    elsif params[:download_pdf] == 'true'
      @account.general_ledgers.to_pdf(current_user.userable.id, @account.id, params[:date_from], params[:date_to])
      flash.now[:notice] = "PDF will be generated and will be ready for download once done"
    end
  end

  # GET /treasury/accounts/new
  def new
    @account = Treasury::Account.new
  end

  # GET /treasury/accounts/1/edit
  def edit
  end

  # POST /treasury/accounts
  def create
    @account = Treasury::Account.new(treasury_account_params)

    if @account.save
      redirect_to @account, notice: "Account was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /treasury/accounts/1
  def update
    if @account.update(treasury_account_params)
      redirect_to @account, notice: "Account was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /treasury/accounts/1
  def destroy
    @account.destroy
    redirect_to treasury_accounts_url, notice: "Account was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_treasury_account
    @account = Treasury::Account.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def treasury_account_params
    params.require(:treasury_account).permit(:name, :account_type, :is_check_account, :contact_number, :address)
  end
end
