class Treasury::BillingStatementsController < ApplicationController
  before_action :set_treasury_billing_statement, only: %i[ show edit update destroy ]

  # GET /treasury/billing_statements
  def index
    @treasury_billing_statements = Treasury::BillingStatement.all
  end

  # GET /treasury/billing_statements/1
  def show
  end

  # GET /treasury/billing_statements/new
  def new
    @treasury_billing_statement = Treasury::BillingStatement.new
  end

  # GET /treasury/billing_statements/1/edit
  def edit
  end

  # POST /treasury/billing_statements
  def create
    @treasury_billing_statement = Treasury::BillingStatement.new(treasury_billing_statement_params)

    if @treasury_billing_statement.save
      redirect_to @treasury_billing_statement, notice: "Billing statement was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /treasury/billing_statements/1
  def update
    if @treasury_billing_statement.update(treasury_billing_statement_params)
      redirect_to @treasury_billing_statement, notice: "Billing statement was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /treasury/billing_statements/1
  def destroy
    @treasury_billing_statement.destroy
    redirect_to treasury_billing_statements_url, notice: "Billing statement was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_treasury_billing_statement
      @treasury_billing_statement = Treasury::BillingStatement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def treasury_billing_statement_params
      params.require(:treasury_billing_statement).permit(:bs_no, :bs_date, :cashier_entry_id)
    end
end
