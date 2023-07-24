class LoanInsurance::BatchRemitsController < ApplicationController
  before_action :set_batch_remit, only: %i[ show edit update destroy ]

  # GET /loan_insurance/batch_remits
  def index
    @batch_remits = LoanInsurance::BatchRemit.all
  end

  # GET /loan_insurance/batch_remits/1
  def show
  end

  # GET /loan_insurance/batch_remits/new
  def new
    @batch_remit = LoanInsurance::BatchRemit.new
  end

  # GET /loan_insurance/batch_remits/1/edit
  def edit
  end

  # POST /loan_insurance/batch_remits
  def create
    @batch_remit = LoanInsurance::BatchRemit.new(batch_remit_params)

    if @batch_remit.save
      redirect_to @batch_remit, notice: "Batch remit was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /loan_insurance/batch_remits/1
  def update
    if @batch_remit.update(batch_remit_params)
      redirect_to @batch_remit, notice: "Batch remit was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /loan_insurance/batch_remits/1
  def destroy
    @batch_remit.destroy
    redirect_to batch_remits_url, notice: "Batch remit was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch_remit
      @batch_remit = LoanInsurance::BatchRemit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def batch_remit_params
      params.fetch(:batch_remit, {})
    end
end
