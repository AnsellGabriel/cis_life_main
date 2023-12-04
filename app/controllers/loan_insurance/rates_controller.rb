class LoanInsurance::RatesController < ApplicationController
  before_action :set_rate, only: %i[ show edit update destroy ]

  # GET /loan_insurance/rates
  def index
    @rates = LoanInsurance::Rate.all
    @grouped_rates = @rates.group_by(&:agreement)
  end

  # GET /loan_insurance/rates/1
  def show
  end

  # GET /loan_insurance/rates/new
  def new
    @rate = LoanInsurance::Rate.new
  end

  # GET /loan_insurance/rates/1/edit
  def edit
  end

  # POST /loan_insurance/rates
  def create
    @rate = LoanInsurance::Rate.new(rate_params)

    if @rate.save
      redirect_to @rate, notice: "Rate was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /loan_insurance/rates/1
  def update
    if @rate.update(rate_params)
      redirect_to @rate, notice: "Rate was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /loan_insurance/rates/1
  def destroy
    @rate.destroy
    redirect_to rates_url, notice: "Rate was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_rate
    @rate = LoanInsurance::Rate.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def rate_params
    params.require(:loan_insurance_rate).permit(:agreement_id, :min_age, :max_age, :monthly_rate, :annual_rate, :daily_rate, :min_amount, :max_amount)
  end
end
