class Treasury::BillingStatementsController < ApplicationController
  include Treasuries::Path

  before_action :set_entry_and_bills, only: %i[ new create edit update destroy]

  def index
    @treasury_billing_statements = Treasury::BillingStatement.all
  end

  def show
  end

  # GET /entries/:entry_id/billing_statements/new
  def new
    @bill = @bills.new
  end

  def edit
    @bill = @bills.find(params[:id])
  end

  def create
    @bill = @bills.new(treasury_billing_statement_params)

    if @bill.save
      redirect_to entry_path, notice: "Billing statement added"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @bill = @bills.find(params[:id])

    if @bill.update(treasury_billing_statement_params)
      redirect_to entry_path, notice: "Billing statement updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bill = @bills.find(params[:id])

    if @bill.destroy
      redirect_to entry_path, alert: "Billing statement deleted", status: :see_other
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_treasury_billing_statement
      @treasury_billing_statement = Treasury::BillingStatement.find(params[:id])
    end

    def set_entry_and_bills
      @entry = Treasury::CashierEntry.find(params[:entry_id])
      @bills = @entry.bills
    end

    # Only allow a list of trusted parameters through.
    def treasury_billing_statement_params
      params.require(:treasury_billing_statement).permit(:bs_no, :bs_date)
    end
end
