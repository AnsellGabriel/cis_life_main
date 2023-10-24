class Treasury::AccountsController < ApplicationController
  before_action :set_treasury_account, only: %i[ show edit update destroy ]

  # GET /treasury/accounts
  def index
    @treasury_accounts = Treasury::Account.all
  end

  # GET /treasury/accounts/1
  def show
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
