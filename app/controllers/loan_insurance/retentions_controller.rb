class LoanInsurance::RetentionsController < ApplicationController
  before_action :set_retention, only: %i[ show edit update destroy ]

  # GET /loan_insurance/retentions
  def index
    @retentions = LoanInsurance::Retention.all
  end

  # GET /loan_insurance/retentions/1
  def show
  end

  # GET /loan_insurance/retentions/new
  def new
    @retention = LoanInsurance::Retention.new
  end

  # GET /loan_insurance/retentions/1/edit
  def edit
  end

  # POST /loan_insurance/retentions
  def create
    @retention = LoanInsurance::Retention.new(retention_params)

    if @retention.save
      redirect_to @retention, notice: "Retention was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /loan_insurance/retentions/1
  def update
    if @retention.update(retention_params)
      redirect_to @retention, notice: "Retention was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /loan_insurance/retentions/1
  def destroy
    @retention.destroy
    redirect_to retentions_url, notice: "Retention was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_retention
    @retention = LoanInsurance::Retention.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def retention_params
    params.require(:retention).permit(:amount, :active, :date_activated, :date_deactivated)
  end
end
