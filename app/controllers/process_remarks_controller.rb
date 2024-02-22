class ProcessRemarksController < ApplicationController
  before_action :authenticate_user!
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
    when "Reassess" then "Process for Reassessment"
    when "Reprocess" then "Request for Reprocess"
    else
      "Add Remark"
    end
    
    
    # binding.pry
    
    @process_status = params[:pro_status]
    @total_life_cov = params[:total_life_cov].to_i
    @max_amount = params[:max_amount].to_i
    @total_gross_prem = params[:total_gross_prem].to_i

    @process_coverage = ProcessCoverage.find_by(id: params[:ref])
    # binding.pry

    if @process_status == "Approve" || @process_status == "Deny"

      if current_user.rank == "analyst"
        if @max_amount >= @total_gross_prem
          # if @process_coverage.group_remit.batches.where(batches: { insurance_status: :denied} ).count > 0
          klass_name = @process_coverage.group_remit.batches.first.class.name
          # denied_count =  @process_coverage.count_batches_denied(klass_name)
          denied_count =  @process_coverage.count_batches("denied")

          if denied_count > 0
            @rem_status = "for_head_approval"
          else
            @rem_status = "approved"
          end
        else
          @rem_status = "for_head_approval"
        end
      elsif current_user.rank == "head"
        if @max_amount >= @total_gross_prem
          @rem_status = "approved"
        else
          @rem_status = "for_vp_approval"
        end
      elsif current_user.rank == "senior_officer"
        @rem_status = "approved"
      end

    else
      @rem_status = params[:rem_status]
    end



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

    @pagy_rem, @filtered_remarks  = pagy(@process_remarks, items: 5, page_param: :pr, link_extra: 'data-turbo-frame="pagination1"')
  end

  # GET /process_remarks/1/edit
  def edit
  end

  # POST /process_remarks or /process_remarks.json
  def create
    # raise 'errors'
    @process_coverage = ProcessCoverage.find(params[:process_remark][:process_coverage_id])
    agreement = @process_coverage.group_remit.agreement.decorate
    @batch_count = @process_coverage.count_pending_for_review_batches(@process_coverage.group_remit.batches.first.class.name)

    if agreement.is_gyrt?
      @dependent_count = @process_coverage.count_pending_for_review_dep(@process_coverage.get_batch_class_name)
    else
      @dependent_count = 0
    end

    unless params[:process_remark][:process_status].nil? || params[:process_remark][:process_status].empty?
      if @batch_count > 0
        return redirect_to process_coverage_path(@process_coverage), alert: "Can't proceed. There are #{@batch_count} #{'coverage'.pluralize(@batch_count)} for review or pending"
      end

      unless @process_coverage.get_plan_acronym == "LPPI"
        if @dependent_count > 0
          return redirect_to process_coverage_path(@process_coverage), alert: "Can't proceed. There are #{@dependent_count} dependent #{'coverage'.pluralize(@batch_count)} for review or pending"
        end
      end

    else
      params[:process_remark][:status] = ""
    end

    @process_remark = ProcessRemark.new(process_remark_params)
    @process_remark.user_type = current_user.userable_type
    @process_remark.user_id = current_user.userable_id
    # raise 'errors'
    respond_to do |format|
      if @process_remark.save
        # binding.pry
        if params[:process_remark][:process_status] == "Approve"

          if agreement.is_lppi?
            group_remit = @process_coverage.group_remit
            group_remit.batches.where(insurance_status: :denied).each do |batch|
              if batch.unused_loan_id.present?
                LoanInsurance::Batch.find(batch.unused_loan_id).update(status: :recent)
              end
            end
          end

          format.html { redirect_to process_coverage_approve_path(process_coverage_id: params[:process_remark][:process_coverage_id], total_life_cov: params[:process_remark][:total_life_cov], max_amount: params[:process_remark][:max_amount], total_gross_prem: params[:process_remark][:total_gross_prem])}
        elsif params[:process_remark][:process_status] == "Deny"
          format.html { redirect_to process_coverage_deny_path(process_coverage_id: params[:process_remark][:process_coverage_id])}
        elsif params[:process_remark][:process_status] == "Reassess"
          format.html { redirect_to process_coverage_reassess_path(process_coverage_id: params[:process_remark][:process_coverage_id])}
        elsif params[:process_remark][:process_status] == "Reprocess"
          format.html { redirect_to process_coverage_reprocess_path(process_coverage_id: params[:process_remark][:process_coverage_id])}
        else
          format.html { redirect_to process_coverage_url(params[:process_remark][:process_coverage_id]), notice: "Process remark was successfully created." }
          format.json { render :show, status: :created, location: @process_remark }
        end
        # format.html { redirect_back fallback_location:, notice: "Process remark was successfully created." }

        # agreement = @process_coverage.group_remit.agreement

        # if agreement.anniversary_type == 'none' or agreement.anniversary_type.nil?
        #   # current_batch_remit = agreement.group_remits.find_by(type: 'BatchRemit', effectivity_date: Date.today.beginning_of_month)
        #   current_batch_remit = agreement.group_remits.find_by(type: 'BatchRemit')
        #   approved_batches = @process_coverage.group_remit.batches.where(insurance_status: :approved)
        #   approved_batches.update_all(batch_remit_id: current_batch_remit.id)
        # end
      else
        # format.html { render :new, status: :unprocessable_entity }
        format.html { redirect_to process_coverage_url(params[:process_remark][:process_coverage_id]), alert: "Remarks not added. Remark should be present." }
        # format.turbo_stream { render :form_update, status: :unprocessable_entity }
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
