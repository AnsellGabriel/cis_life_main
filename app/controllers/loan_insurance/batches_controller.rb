class LoanInsurance::BatchesController < ApplicationController
  before_action :set_batch, only: %i[ show edit update destroy ]

  # GET /loan_insurance/batches
  def index
    @batches = LoanInsurance::Batch.all
  end

  # GET /loan_insurance/batches/1
  def show
  end

  # GET /loan_insurance/batches/new
  def new
    @batch = LoanInsurance::Batch.new
  end

  # GET /loan_insurance/batches/1/edit
  def edit
  end

  # POST /loan_insurance/batches
  def create
    @batch = LoanInsurance::Batch.new(batch_params)

    if @batch.save
      redirect_to @batch, notice: "Batch was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /loan_insurance/batches/1
  def update
    if @batch.update(batch_params)
      redirect_to @batch, notice: "Batch was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /loan_insurance/batches/1
  def destroy
    @batch.destroy
    redirect_to batches_url, notice: "Batch was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = LoanInsurance::Batch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def batch_params
      params.fetch(:batch, {})
    end
end