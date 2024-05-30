class LoanInsurance::BatchesController < ApplicationController
  before_action :set_batch, only: %i[ show edit update destroy ]
  before_action :set_group_remit, only: %i[ new import edit]

  def import
    import_service = CsvImportService.new(
      @group_remit.agreement.plan.acronym == "SII" ? :sii : :lppi,
      params[:file],
      @cooperative,
      @group_remit,
      current_user
    )

    import_result = import_service.import

    if import_result.is_a?(Hash)
      notice = "#{import_result[:added_members_counter]} members successfully added. #{import_result[:denied_members_counter]} members denied."
      if @group_remit.agreement.plan.acronym == "SII"
        redirect_to loan_insurance_group_remit_path(@group_remit,p: "sii"), notice: notice
      else
        redirect_to loan_insurance_group_remit_path(@group_remit), notice: notice
      end
    else
      if @group_remit.agreement.plan.acronym == "SII"
        redirect_to loan_insurance_group_remit_path(@group_remit, p: "sii"), notice: import_result
      else
        redirect_to loan_insurance_group_remit_path(@group_remit), notice: import_result
      end
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
    # raise 'errors'
    if params[:loan_insurance_batch][:coop_member_id].empty?
      return redirect_to loan_insurance_group_remit_path(params[:loan_insurance_batch][:group_remit_id]), alert: "Please select a member"
    end

    @coop_members = @cooperative.coop_members
    @group_remit_id = params[:loan_insurance_batch][:group_remit_id]
    agreement = GroupRemit.find(@group_remit_id).agreement
    # params[:loan_insurance_batch][:unused_loan_id] = params[:loan_insurance_batch][:unused_loan_id].to_i if params[:loan_insurance_batch][:unused_loan_id].present?
    params[:loan_insurance_batch][:loan_amount] = params[:loan_insurance_batch][:loan_amount].gsub(",", "").to_d
    @batch = LoanInsurance::Batch.new(batch_params)
    @batch.loan_amount = nil if @batch.loan_amount <= 0
    if agreement.plan.acronym == "SII"
      result = @batch.sii_process_batch
    else
      ecoded_prem = params[:loan_insurance_batch][:encoded_premium].empty? ? nil : params[:loan_insurance_batch][:encoded_premium].to_f
      result = @batch.process_batch(ecoded_prem)
    end

    respond_to do |format|
      if @batch.save
        if agreement.plan.acronym == "SII"
          format.html { redirect_to loan_insurance_group_remit_path(params[:loan_insurance_batch][:group_remit_id], p: "sii"), notice: "Member added" }
        else
          format.html { redirect_to loan_insurance_group_remit_path(params[:loan_insurance_batch][:group_remit_id]), notice: "Member added" }
        end
      elsif result == :no_rate_for_age
        if agreement.plan.acronym == "SII"
          format.html {
            redirect_to loan_insurance_group_remit_path(params[:loan_insurance_batch][:group_remit_id], p: "sii"),
            alert: "No available rate for member's age: #{@batch.age}" }
        else
          format.html {
            redirect_to loan_insurance_group_remit_path(params[:loan_insurance_batch][:group_remit_id]),
            alert: "No available rate for member's age: #{@batch.age}" }
        end
      elsif result == :no_rate_for_amount
        if agreement.plan.acronym == "SII"
          format.html {
            redirect_to loan_insurance_group_remit_path(params[:loan_insurance_batch][:group_remit_id], p: "sii"),
            alert: "No available rate for loan amount: #{ActionController::Base.helpers.number_to_currency(@batch.loan_amount, unit: "")}" }
        else
          format.html {
            redirect_to loan_insurance_group_remit_path(params[:loan_insurance_batch][:group_remit_id]),
            alert: "No available rate for loan amount: #{ActionController::Base.helpers.number_to_currency(@batch.loan_amount, unit: "")}" }
        end
      else
        format.turbo_stream do
          if agreement.plan.acronym == "SII"
            render turbo_stream: turbo_stream.replace("new_loan_insurance_batch", partial: "loan_insurance/batches/sii_form", locals: {batch: @batch, coop_members: @coop_members, group_remit_id: @group_remit_id}),
            status: :unprocessable_entity
          else
            render turbo_stream: turbo_stream.replace("new_loan_insurance_batch", partial: "loan_insurance/batches/form", locals: {batch: @batch, coop_members: @coop_members, group_remit_id: @group_remit_id}),
            status: :unprocessable_entity

          end
        end
      end
    end
  end

  # PATCH/PUT /loan_insurance/batches/1
  def update
    @group_remit = @batch.group_remit

    begin
      @batch.transaction do

        @batch.update!(batch_params)
        @batch.rate = nil
        result = @batch.process_batch

        if result == :no_rate_for_amount
          raise ActiveRecord::RangeError
        end

        @batch.save!

        redirect_to loan_insurance_group_remit_path(batch_params[:group_remit_id]), notice: "Loan details updated"
      end
    rescue ActiveRecord::RangeError => e
      @batch.errors.add(:loan_amount, "doesn't have a rate available")
      render :edit, status: :unprocessable_entity
    end

    # @batch.transaction do
    #   if @batch.update(batch_params)
    #     result = @batch.process_batch
    #   else


    #   # if result
    #   #   redirect_to loan_insurance_group_remit_path(batch_params[:group_remit_id]), notice: "Loan details was successfully updated"
    #   # else
    #   #   case result
    #   #   when :no_rate_for_amount
    #   #     redirect_to loan_insurance_group_remit_path(@batch.group_remit), alert: "No rate for the loan amount"
    #   #   when :no_rate_for_age
    #   #     redirect_to loan_insurance_group_remit_path(@batch.group_remit), alert: "No rate for the member's age"
    #   #   when :no_loan_rate
    #   #     redirect_to loan_insurance_group_remit_path(@batch.group_remit), alert: "No loan rate found"
    #   #   when :no_dates
    #   #     redirect_to loan_insurance_group_remit_path(@batch.group_remit), alert: "No effectivity date or expiry date"
    #   #   else
    #   #     redirect_to loan_insurance_group_remit_path(@batch.group_remit), alert: "Something went wrong. Please try again"
    #   #   end

    #   #   raise ActiveRecord::Rollback
    #   # end
    # end

    # if @batch.update(batch_params)
    #   redirect_to loan_insurance_group_remit_path(batch_params[:group_remit_id]), notice: "Batch was successfully updated."
    # else
    #   render :edit, status: :unprocessable_entity
    # end
  end

  def remove_unused
    batch = LoanInsurance::Batch.find(params[:id])
    @unused_Loan = LoanInsurance::Batch.find(batch.unused_loan_id)

    @unused_Loan.update!(status: :recent, terminate_date: nil)
    batch.update!(unused_loan_id: nil, excess: 0)
    loan_rate = LoanInsurance::Rate.find(batch.loan_insurance_rate_id)
    batch.calculate_values(batch.group_remit.agreement, loan_rate)

    if batch.save!
      redirect_to loan_insurance_group_remit_path(batch.group_remit), alert: "Unused loan removed"
    end
  end

  # DELETE /loan_insurance/batches/1
  def destroy
    @batch.transaction do
      if @batch.unused_loan_id.present?
        LoanInsurance::Batch.find(@batch.unused_loan_id).update(status: :recent)
      end

      if @batch.destroy!
        redirect_to loan_insurance_group_remit_path(@batch.group_remit), alert: "Member removed"
      end
    end
  end

  def terminate
    batch = LoanInsurance::Batch.find(params[:id])
    coop_member = batch.coop_member

    if batch.update(status: :terminated)
      batch.batch_remarks.create!(remark: "Loan terminated by the cooperative.", user: current_user, status: :terminated)

      redirect_to show_insurance_coop_member_path(coop_member), alert: "Member loan terminated"
    end
  end

  def approve_all
    @process_coverage = ProcessCoverage.find(params[:process_coverage])
    @batches = @process_coverage.get_batches
    approved_count = 0
    for_approved_count = 0

    @batches.each do |batch|
      if batch.insurance_status == "for_review" || batch.insurance_status == "pending"
        for_approved_count += 1
        # if (18..65).include?(batch.age)
        # if (batch.agreement_benefit.min_age..batch.agreement_benefit.max_age).include?(batch.age)
        if batch.get_rate_age_range
          if batch.valid_health_dec
            batch.update_attribute(:insurance_status, "approved") if batch.valid_health_dec
            approved_count += 1
          end
          # @process_coverage.increment!(:approved_count)

        end
      end
    end

    # redirect_to process_coverage_path(@process_coverage), notice: "Batches have been approved!"
    if approved_count == for_approved_count
      redirect_to process_coverage_path(@process_coverage), notice: "All batches have been approved!"
    elsif approved_count < for_approved_count && approved_count > 0
      redirect_to process_coverage_path(@process_coverage), notice: "#{approved_count} batch(es) have been approved!"
    else
      redirect_to process_coverage_path(@process_coverage), alert: "No batches have been approved!"
    end

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
