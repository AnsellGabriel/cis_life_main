class LoanInsurance::BatchesController < ApplicationController
  before_action :set_batch, only: %i[ show edit update destroy ]
  before_action :set_group_remit, only: %i[ new ]

  # GET /loan_insurance/batches
  def index
    @batches = LoanInsurance::Batch.all.order(created_at: :desc)
  end

  # GET /loan_insurance/batches/1
  def show
    @member = @batch.member_details
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
    @group_remit_id = params[:group_remit_id]
    # @member = Member.find(1)
  end

  # GET /loan_insurance/batches/1/edit
  def edit
  end

  # POST /loan_insurance/batches
  def create
    @coop_members = @cooperative.coop_members
    @group_remit_id = params[:loan_insurance_batch][:group_remit_id]
    @batch = LoanInsurance::Batch.new(batch_params)
    @batch.process_batch
    
    respond_to do |format|
      if @batch.save
        format.html { redirect_to loan_insurance_group_remit_path(params[:loan_insurance_batch][:group_remit_id]), notice: "Member added" }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_loan_insurance_batch", partial: "loan_insurance/batches/form", locals: {batch: @batch, coop_members: @coop_members, group_remit_id: @group_remit_id}), status: :unprocessable_entity
        end
      end
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
    @batch.destroy!
    redirect_to loan_insurance_group_remit_path(@batch.group_remit), alert: "Member removed"
  end

  private
    # Only allow a list of trusted parameters through.
    def batch_params
      params.require(:loan_insurance_batch).permit(:group_remit_id, :coop_member_id, :loan_amount, :terms, :effectivity_date, :expiry_date, :date_release, :date_mature, :loan_insurance_loan_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = LoanInsurance::Batch.find(params[:id])
    end

    def set_group_remit
      @group_remit = LoanInsurance::GroupRemit.find(params[:group_remit_id])
    end
end
