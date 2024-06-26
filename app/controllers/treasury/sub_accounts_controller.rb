class Treasury::SubAccountsController < ApplicationController
  include Treasuries::Ledgerable

  before_action :set_sub_account, only: %i[ show edit update destroy ]

  # GET /treasury/sub_accounts
  def index
    @q = Treasury::SubAccount.ransack(params[:q])
    @sub_accounts = @q.result(distinct: true)
  end

  # GET /treasury/sub_accounts/1
  def show
    # concerns/treasuries/ledgerable.rb
    set_dates
    set_ledger_and_pagy
    compute_balance

    if params[:download_csv] == 'true'
      @account.general_ledgers.to_csv(current_user.userable.id, @account.id, params[:date_from], params[:date_to], true)
      flash.now[:notice] = "CSV will be generated and will be ready for download once done"
    elsif params[:download_pdf] == 'true'
      @account.general_ledgers.to_pdf(current_user.userable.id, @account.id, params[:date_from], params[:date_to], true)
      flash.now[:notice] = "PDF will be generated and will be ready for download once done"
    end
  end

  # GET /treasury/sub_accounts/new
  def new
    @account = Treasury::SubAccount.new
  end

  # GET /treasury/sub_accounts/1/edit
  def edit
  end

  # POST /treasury/sub_accounts
  def create
    @account = Treasury::SubAccount.new(treasury_sub_account_params)

    if @account.save
      redirect_to @account, notice: "Sub Account was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /treasury/sub_accounts/1
  def update
    if @account.update(treasury_sub_account_params)
      redirect_to @treasury_sub_account, notice: "Sub account was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /treasury/sub_accounts/1
  def destroy
    @account.destroy
    redirect_to treasury_sub_accounts_url, notice: "Sub account was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_account
      @account = Treasury::SubAccount.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def treasury_sub_account_params
      params.require(:treasury_sub_account).permit(:name, :description)
    end
end
