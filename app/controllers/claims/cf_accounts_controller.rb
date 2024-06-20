class Claims::CfAccountsController < ApplicationController
  before_action :set_cf_account, only: %i[ show edit update destroy ]

  # GET /cf_accounts
  def index
    @cf_accounts = Claims::CfAccount.all
  end

  # GET /cf_accounts/1
  def show
  end

  # GET /cf_accounts/new
  def new
    @cf_account = Claims::CfAccount.new
  end

  # GET /cf_accounts/1/edit
  def edit
  end

  # POST /cf_accounts
  def create
    @cf_account = Claims::CfAccount.new(cf_account_params)
    @cf_account.status = :active
    if @cf_account.save
      redirect_to claims_cf_accounts_path, notice: "Claims fund account was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cf_accounts/1
  def update
    if @cf_account.update(cf_account_params)
      redirect_to claims_cf_accounts_path, notice: "Claims fund account was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /cf_accounts/1
  def destroy
    @cf_account.update(status: :deactivate)
    redirect_to claims_cf_accounts_path, alert: "Claims fund account was deactived.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cf_account
      @cf_account = Claims::CfAccount.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cf_account_params
      params.require(:claims_cf_account).permit(:cooperative_id, :amount, :amount_limit, :status)
    end
end
