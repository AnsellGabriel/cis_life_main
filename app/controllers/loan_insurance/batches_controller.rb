class LoanInsurance::BatchesController < ApplicationController
  before_action :set_batch, only: %i[ show edit update destroy ]
  before_action :set_group_remit, only: %i[ new import]

  def import
    import_service = CsvImportService.new(
      :lppi,
      params[:file],
      @cooperative,
      @group_remit
    )

    import_result = import_service.import

    if import_result.is_a?(Hash)
      notice = "#{import_result[:added_members_counter]} members successfully added. #{import_result[:denied_members_counter]} members denied."
      redirect_to loan_insurance_group_remit_path(@group_remit), notice: notice
    else
      redirect_to loan_insurance_group_remit_path(@group_remit), notice: import_result
    end
  end

  # GET /loan_insurance/batches
  def index
    @batches = LoanInsurance::Batch.all.order(created_at: :desc)
  end

  # GET /loan_insurance/batches/1
  def show
    @member = @batch.member_details
  end

  def find_loan
    @batch = LoanInsurance::Batch.find(params[:id])

    respond_to do |format|
      format.turbo_stream
    end
  end

  def show_unuse_batch
    @batch = LoanInsurance::Batch.find(params[:id])
  end

  def modal_remarks
    @batch = LoanInsurance::Batch.find(params[:id])
    @group_remit = @batch.group_remit
    @agreement = @group_remit.agreement
  end

  # GET /loan_insurance/batches/new
  def new
    @batch = @group_remit.batches.build(
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
    agreement = GroupRemit.find(@group_remit_id).agreement
    # params[:loan_insurance_batch][:unused_loan_id] = params[:loan_insurance_batch][:unused_loan_id].to_i if params[:loan_insurance_batch][:unused_loan_id].present?
    params[:loan_insurance_batch][:loan_amount] = params[:loan_insurance_batch][:loan_amount].gsub(',', '').to_d
    @batch = LoanInsurance::Batch.new(batch_params)
    result = @batch.process_batch

    respond_to do |format|
      if @batch.save
        format.html { redirect_to loan_insurance_group_remit_path(params[:loan_insurance_batch][:group_remit_id]), notice: "Member added" }
      elsif result == :no_loan_rate
        format.html { redirect_to loan_insurance_group_remit_path(params[:loan_insurance_batch][:group_remit_id]), alert: "Acceptable age for this plan: #{agreement.entry_age_from}-#{agreement.exit_age}. Member's age: #{@batch.age}" }
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


  def approve_all
    @process_coverage = ProcessCoverage.find(params[:process_coverage])
    @batches = @process_coverage.get_batches
    
    @batches.each do |batch|
      if batch.insurance_status == "for_review" || batch.insurance_status == "pending"
        # if (18..65).include?(batch.age)
        # if (batch.agreement_benefit.min_age..batch.agreement_benefit.max_age).include?(batch.age)
        if batch.get_rate_age_range
          batch.update_attribute(:insurance_status, "approved")
          # @process_coverage.increment!(:approved_count)
          
        end
      end
    end
    
    redirect_to process_coverage_path(@process_coverage), notice: "Batches have been approved!"

  end

  private
    # Only allow a list of trusted parameters through.
    def batch_params
      params.require(:loan_insurance_batch).permit(:group_remit_id, :coop_member_id, :loan_amount, :terms, :effectivity_date, :expiry_date, :date_release, :date_mature, :loan_insurance_loan_id, :unused_loan_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = LoanInsurance::Batch.find(params[:id])
    end

    def set_group_remit
      @group_remit = LoanInsurance::GroupRemit.find(params[:group_remit_id])
    end
end
