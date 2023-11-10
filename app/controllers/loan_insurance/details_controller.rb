class LoanInsurance::DetailsController < ApplicationController
  before_action :set_loan_insurance_detail, only: %i[ show edit update destroy ]

  # GET /loan_insurance/details
  def index
    @loan_insurance_details = LoanInsurance::Detail.all
  end

  # GET /loan_insurance/details/1
  def show
  end

  # GET /loan_insurance/details/new
  def new
    @loan_insurance_detail = LoanInsurance::Detail.new
  end

  # GET /loan_insurance/details/1/edit
  def edit
  end

  # POST /loan_insurance/details
  def create
    @loan_insurance_detail = LoanInsurance::Detail.new(loan_insurance_detail_params)

    if @loan_insurance_detail.save
      redirect_to @loan_insurance_detail, notice: "Detail was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /loan_insurance/details/1
  def update
    if @loan_insurance_detail.update(loan_insurance_detail_params)
      redirect_to @loan_insurance_detail, notice: "Detail was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /loan_insurance/details/1
  def destroy
    @loan_insurance_detail.destroy
    redirect_to loan_insurance_details_url, notice: "Detail was successfully destroyed."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_loan_insurance_detail
    @loan_insurance_detail = LoanInsurance::Detail.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def loan_insurance_detail_params
    params.require(:loan_insurance_detail).permit(:batch_id, :unuse, :loan_amount, :premium_due, :substandard_rate, :terminate, :terinate_date, :reinsurance, :terms, :date_release, :date_mature)
  end
end
