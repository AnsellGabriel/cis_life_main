class LoanInsurance::BatchesController < ApplicationController
  before_action :set_batch, only: %i[ show edit update destroy ]
  before_action :set_group_remit, only: %i[ new ]

  # GET /loan_insurance/batches
  def index
    @batches = LoanInsurance::Batch.all
  end

  # GET /loan_insurance/batches/1
  def show
  end

  # GET /loan_insurance/batches/new
  def new
    @batch = @group_remit.lppi_batches.build(
      terms: 6,
      loan_amount: 500_000,
      date_release: Date.today,
      date_mature: Date.today + 6.months,
      loan: LoanInsurance::Loan.first
    )
    @coop_members = @cooperative.coop_members
  end

  # GET /loan_insurance/batches/1/edit
  def edit
  end

  # POST /loan_insurance/batches
  def create
    @batch = LoanInsurance::Batch.new(batch_params)
    @batch.process_batch
    
    if @batch.save!
      redirect_to loan_insurance_group_remit_path(params[:loan_insurance_batch][:group_remit_id]), notice: "Member added"
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
    # Only allow a list of trusted parameters through.
    def batch_params
      params.require(:loan_insurance_batch).permit(:group_remit_id, :coop_member_id, :loan_amount, :terms, :date_release, :date_mature, :loan_insurance_loan_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = LoanInsurance::Batch.find(params[:id])
    end

    def set_group_remit
      @group_remit = LoanInsurance::GroupRemit.find(params[:group_remit_id])
    end
end
