class ProcessRemarksController < ApplicationController
  before_action :set_process_remark, only: %i[ show edit update destroy ]

  # GET /process_remarks
  def index
    @process_remarks = ProcessRemark.all
  end

  # GET /process_remarks/1
  def show
  end

  # GET /process_remarks/new
  def new
    # raise 'errors'
    @title = case params[:pro_status]
    when "Approve" then "Process Approval"
    when "Deny" then "Process Denial"
    else
      "Add Remark"
    end
    
    @total_life_cov = params[:total_life_cov]
    @max_amount = params[:max_amount]
    @process_status = params[:pro_status]

    if current_user.rank == "analyst"
      if @max_amount >= @total_life_cov
        @rem_status = "approved"
      else
        @rem_status = "for_head_approval"
      end
    elsif current_user.rank == "head"
      if @max_amount >= @total_life_cov
        @rem_status = "approved"
      else
        @rem_status = "for_vp_approval"
      end
    elsif current_user.rank == "senior_officer"
        @rem_status = "approved"
    end

    # @rem_status = params[:rem_status]
    
    @process_coverage = ProcessCoverage.find(params[:ref])
    if Rails.env.development?
      @process_remark = @process_coverage.process_remarks.build(remark: FFaker::Lorem.sentence)
    else
      @process_remark = @process_coverage.process_remarks.build
    end
  end

  def view_all
    @process_coverage = ProcessCoverage.find(params[:process_coverage])
    @process_remarks = @process_coverage.process_remarks
  end

  # GET /process_remarks/1/edit
  def edit
  end

  # POST /process_remarks or /process_remarks.json
  def create
    # raise 'errors'
    @process_coverage = ProcessCoverage.find(params[:process_remark][:process_coverage_id])
    @batch_count = @process_coverage.group_remit.batches.where(batches: { insurance_status: :for_review }).count

    if @batch_count > 0 
      return redirect_to process_coverage_path(@process_coverage), alert: "Can't proceed. There are #{@batch_count} #{'coverage'.pluralize(@batch_count)} for review"
    end
    
    @process_remark = ProcessRemark.new(process_remark_params)
    @process_remark.user_type = current_user.userable_type
    @process_remark.user_id = current_user.userable_id

    respond_to do |format|
      if @process_remark.save
        if params[:process_remark][:process_status] == "Approve"

          format.html { redirect_to process_coverage_approve_path(process_coverage_id: params[:process_remark][:process_coverage_id], total_life_cov: params[:process_remark][:total_life_cov], max_amount: params[:process_remark][:max_amount])}
        elsif params[:process_remark][:process_status] == "Deny"
          format.html { redirect_to process_coverage_deny_path(process_coverage_id: params[:process_remark][:process_coverage_id])}
        else
          format.html { redirect_to process_coverage_url(params[:process_remark][:process_coverage_id]), notice: "Process remark was successfully created." }
          format.json { render :show, status: :created, location: @process_remark }
        end
        # format.html { redirect_back fallback_location:, notice: "Process remark was successfully created." }
        
        agreement = @process_coverage.group_remit.agreement

        if agreement.anniversary_type == 'none' or agreement.anniversary_type.nil?
          current_batch_remit = agreement.group_remits.find_by(type: 'BatchRemit', effectivity_date: Date.today.beginning_of_month)
          approved_batches = @process_coverage.group_remit.batches.where(insurance_status: :approved)
          approved_batches.update_all(batch_remit_id: current_batch_remit.id)
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @process_remark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /process_remarks/1
  def update
    if @process_remark.update(process_remark_params)
      redirect_to @process_remark, notice: "Process remark was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /process_remarks/1
  def destroy
    @process_remark.destroy
    redirect_to process_remarks_url, notice: "Process remark was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_remark
      @process_remark = ProcessRemark.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def process_remark_params
      params.require(:process_remark).permit(:process_coverage_id, :remark, :status, :user_id, :user_type)
    end
end
