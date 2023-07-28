class LoanInsurance::LoansController < ApplicationController
  before_action :set_loan, only: %i[ show edit update destroy ]

  # GET /loan_insurance/loans
  def index
    @loans = LoanInsurance::Loan.all
  end

  # GET /loan_insurance/loans/1
  def show
  end

  # GET /loan_insurance/loans/new
  def new
    @loan = LoanInsurance::Loan.new
  end

  # GET /loan_insurance/loans/1/edit
  def edit
  end

  # POST /loan_insurance/loans
  def create
    @loan = LoanInsurance::Loan.new(loan_params)

    if @loan.save
      redirect_to @loan, notice: "Loan was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /loan_insurance/loans/1
  def update
    if @loan.update(loan_params)
      redirect_to @loan, notice: "Loan was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /loan_insurance/loans/1
  def destroy
    @loan.destroy
    redirect_to loans_url, notice: "Loan was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan
      @loan = LoanInsurance::Loan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def loan_params
      params.require(:loan).permit(:name, :description, :cooperative_id)
    end
end
