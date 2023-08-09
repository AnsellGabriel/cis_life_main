class BatchRemarksController < ApplicationController
  before_action :set_batch_remark, only: %i[ show edit update destroy ]

  # GET /batch_remarks
  def index
    @batch_remarks = BatchRemark.all
  end

  # GET /batch_remarks/1
  def show
  end

  # GET /batch_remarks/new
  def new
    # @batch_remark = BatchRemark.new
    @title = case params[:batch_status]
      when "Pending" then "Pending Batch"
      when "Deny" then "Deny Batch"
      when "MD" then "Med Dir"
      when "New" then "New Remark" 
      when "For reconsideration" then "Request for reconsideration"
    end

    @batch_status = params[:batch_status]

    @rem_status = case @batch_status
      when "Pending" then :pending
      when "Deny" then :denied
      when "MD" then :md_reco
      when "For reconsideration" then :request
    end

    @process_coverage = params[:pro_cov]

    @batch = Batch.find(params[:ref])
    @batch_remark = @batch.batch_remarks.build
  end

  def form_md

    # @batch_status = "MD"

    # @rem_status = :md_reco
    # @process_coverage = @batch.group_remit.process_coverage

    # @batch = Batch.find(params[:batch])
    # @batch_remark = @batch.batch_remarks.build
    
  end

  # GET /batch_remarks/1/edit
  def edit
  end

  # POST /batch_remarks
  def create
    # raise 'errors'
    # @batch_remark = BatchRemark.new(batch_remark_params)
    @batch_remark = BatchRemark.new(batch_remark_params)
    @batch_remark.user_type = current_user.userable_type
    @batch_remark.user_id = current_user.userable_id
    
    @batch = Batch.find_by(id: params[:batch_remark][:batch_id])
    @process_coverage = ProcessCoverage.find_by(id: params[:batch_remark][:process_coverage])

    respond_to do |format|
      
      if @batch_remark.save
        # redirect_to @batch_remark, notice: "Batch remark was successfully created."
        if params[:batch_remark][:batch_status] == "Pending"
          format.html { redirect_to pending_batch_process_coverage_path(id: @process_coverage.id, batch: @batch)}
        elsif params[:batch_remark][:batch_status] == "Deny"
          format.html { redirect_to deny_batch_process_coverage_path(id: @process_coverage.id, batch: @batch)}
        elsif params[:batch_remark][:batch_status] == "New"
          format.html { redirect_to process_coverage_path(@process_coverage), notice: "Batch remark created."}
        elsif params[:batch_remark][:batch_status] == "MD"
          # byebug
          @group_remit = @batch.group_remits.find_by(type: "Remittance")
          format.html { redirect_to all_health_decs_group_remit_batches_path(@group_remit.process_coverage), notice: "Recommendation created." } 
        elsif params[:batch_remark][:batch_status] == "For reconsideration"
          @batch.update(insurance_status: :for_reconsideration)
          @group_remit = @batch.group_remits.find_by(type: "Remittance")
          format.html { redirect_to group_remit_path(@group_remit), notice: "Request saved" } 
        else
          format.html { redirect_to batch_remark_url(@batch_remark), notice: "Batch remark was successfully created." }
          format.json { render :show, status: :created, location: @batch_remark }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @batch_remark.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end

    end
  end

  # PATCH/PUT /batch_remarks/1
  def update
    if @batch_remark.update(batch_remark_params)
      redirect_to @batch_remark, notice: "Batch remark was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /batch_remarks/1
  def destroy
    @batch_remark.destroy
    redirect_to batch_remarks_url, notice: "Batch remark was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch_remark
      @batch_remark = BatchRemark.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def batch_remark_params
      params.require(:batch_remark).permit(:batch_id, :remark, :status, :user_id, :user_type, :batch_status, :process_coverage)
    end
end
