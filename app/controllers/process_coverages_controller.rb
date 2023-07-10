class ProcessCoveragesController < ApplicationController
  before_action :set_process_coverage, only: %i[ show edit update destroy approve_batch deny_batch pending_batch ]

  # GET /process_coverages
  def index
    @process_coverages = ProcessCoverage.all
    @for_process_coverages = ProcessCoverage.where(status: :for_process)
    @approved_process_coverages = ProcessCoverage.where(status: :approved)
    @pending_process_coverages = ProcessCoverage.where(status: :pending)
    @denied_process_coverages = ProcessCoverage.where(status: :denied)
  end

  def cov_list
    # raise 'errors'
    @process_coverages = case params[:cov_type]
      when "For Process" then ProcessCoverage.where(status: :for_process)
      when "Approved" then ProcessCoverage.where(status: :approved)
      when "Pending" then ProcessCoverage.where(status: :pending)
      when "Denied" then ProcessCoverage.where(status: :denied)
    end

    @title = params[:title]
    
  end

  def update_batch_selected
    @process_coverage = ProcessCoverage.find_by(params[:p_id])

    if params[:approve]
      ids = params[:ids]
  
      Batch.where(id: ids).update_all(insurance_status: :approved)
      @process_coverage.increment!(:approved_count, ids.length)

      redirect_to process_coverage_path(@process_coverage), notice: "Selected Coverages Approved!"
      
    elsif params[:deny]
      ids = params[:ids]
  
      Batch.where(id: ids).update_all(insurance_status: :denied)
      @process_coverage.increment!(:denied_count, ids.length)

      redirect_to process_coverage_path(@process_coverage), alert: "Selected Coverages Denied!"
    end
    
    # redirect_to process_coverage_path(@process_coverage), notice: "Selected Coverages Approved!"
  end
  

  # GET /process_coverages/1
  def show

    @insured_types = @process_coverage.group_remit.agreement.agreement_benefits.insured_types.symbolize_keys.values
    @insured_types2 = @process_coverage.group_remit.agreement.agreement_benefits
    puts "insured type id: #{@insured_types}"
    if params[:insured_type].present?
      # @batches_o = @group_remit.batches.joins(coop_member: [:member]).where(proposal_insured_id: params[:insured_type_id])
      # @batches_o = @process_coverage.group_remit.batches.joins(coop_member: [:member]).where(proposal_insured_id: params[:insured_type_id])
      @batches_o = @process_coverage.group_remit.batches.joins(coop_member: [:member]).where(agreement_benefit_id: params[:insured_type])
    else
      @batches_o = @process_coverage.group_remit.batches.includes(:coop_member, :member)
    end
    # @batches_o = @process_coverage.group_remit.batches.includes(:coop_member, :member)
    # raise 'errors'
    # if params[:search].present?
    if params[:search].present?
      @batches = case params[:search]
      when "regular_new" then @batches_o.where(age: 18..65, status: 0)
      when "regular_ren" then @batches_o.where(age: 18..65, status: 1)
      when "overage" then @batches_o.where(age: 66..)
        # when "health_decs" then @batches_o.joins(:batch_health_decs)
      when "health_decs" then @batches_o.joins(:batch_health_decs).where(batches: { valid_health_dec: false }).distinct
        # when "health_decs" then @batches_o.joins(:batch_health_dec).where.not(batch_health_decs: { health_dec_question_id: nil })
      end
    else
      @batches = @batches_o
    end
    
    if params[:search_member].present?
      @batches = @batches_o.joins(coop_member: :member).where("members.last_name LIKE ? OR members.first_name LIKE ? OR members.middle_name LIKE ?", "%#{params[:search_member]}%", "%#{params[:search_member]}%", "%#{params[:search_member]}%")
    end

    @pagy_batch, @filtered_batches  = pagy(@batches, items: 10, page_param: :batch)

    @process_cov = ProcessCoverage.includes(group_remit: { batches: [:batch_remarks, coop_member: :member ] }).find(params[:id])

    @process_remarks = @process_coverage.process_remarks

    @pagy_rem, @filtered_remarks = pagy(@process_remarks, items: 3, page_param: :remark)

    # @life_cov = ProcessCoverage.includes(group_remit: { moa: { proposal:{ proposal_insureds: :proposal_insured_benefits }}}).find_by(id: @process_coverage.id).group_remit.moa.proposal.proposal_insureds.joins(:proposal_insured_benefits).where(proposal_insureds: {insured_type: 1}, proposal_insured_benefits: {benefit: 1}).pluck('proposal_insured_benefits.cov_amount').first

    @life_cov = ProcessCoverage.includes(group_remit: { agreement: { agreement_benefits: :product_benefits }}).find_by(id: @process_coverage.id).group_remit.agreement.agreement_benefits.joins(:product_benefits).where(agreement_benefits: {insured_type: 1}, product_benefits: {benefit_id: 1}).pluck('product_benefits.coverage_amount').first
    
    @group_remit = @process_coverage.group_remit
    # raise 'errors'
    puts "#{@life_cov} ********************************"
  end

  # GET /process_coverages/new
  def new
    @process_coverage = ProcessCoverage.new
  end

  def approve
    # byebug
    @process_coverage = ProcessCoverage.find_by(id: params[:process_coverage_id])

    respond_to do |format|
      if @process_coverage.update_attribute(:status, "approved")
        format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage Approved!" }
      end
    end
  end
  
  def deny
    @process_coverage = ProcessCoverage.find_by(id: params[:process_coverage_id])
    
    respond_to do |format|
      if @process_coverage.update_attribute(:status, "denied")
        format.html { redirect_to process_coverage_path(@process_coverage), alert: "Process Coverage Denied!" }
      end
    end
  end

  def approve_batch
    # raise 'errors'
    @batch = Batch.find(params[:batch])

    respond_to do |format|
      if @batch.update_attribute(:insurance_status, 0)
        @process_coverage.increment!(:approved_count)
        format.html { redirect_to process_coverage_path(@process_coverage), notice: "Batch Approved!" }
      end
    end
  end

  def pending_batch
    # raise 'errors'
    @batch = Batch.find(params[:batch])

    respond_to do |format|
      if @batch.update_attribute(:insurance_status, 2)
        format.html { redirect_to process_coverage_path(@process_coverage), notice: "Pending batch updated!" }
      end
    end
  end

  def deny_batch
    @batch = Batch.find(params[:batch])

    respond_to do |format|
      if @batch.update_attribute(:insurance_status, 1)
        @process_coverage.increment!(:denied_count)
        format.html { redirect_to process_coverage_path(@process_coverage), alert: "Batch Denied!" }
      end
    end
  end

  def modal_remarks
    @batch = Batch.find(params[:batch])
  end

  # GET /process_coverages/1/edit
  def edit
  end

  # POST /process_coverages
  def create
    @process_coverage = ProcessCoverage.new(process_coverage_params)

    if @process_coverage.save
      redirect_to @process_coverage, notice: "Process coverage was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /process_coverages/1
  def update
    if @process_coverage.update(process_coverage_params)
      redirect_to @process_coverage, notice: "Process coverage was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /process_coverages/1
  def destroy
    @process_coverage.destroy
    redirect_to process_coverages_url, notice: "Process coverage was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_coverage
      @process_coverage = ProcessCoverage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def process_coverage_params
      params.require(:process_coverage).permit(:group_remit_id, :agent_id, :effectivity, :expiry, :status, :approved_count, :approved_total_coverage, :approved_total_prem, :denied_count, :denied_total_coverage, :denied_total_prem)
    end
end
