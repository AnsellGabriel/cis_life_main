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

    @process_status = params[:pro_status]
    @rem_status = params[:rem_status]
    
    @process_coverage = ProcessCoverage.find(params[:ref])
    @process_remark = @process_coverage.process_remarks.build(remark: FFaker::Lorem.sentence)
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
    @process_remark = ProcessRemark.new(process_remark_params)
    @process_remark.user_type = current_user.userable_type
    @process_remark.user_id = current_user.userable_id

    respond_to do |format|
      if @process_remark.save
        if params[:process_remark][:process_status] == "Approve"
          group_remit = ProcessCoverage.find(params[:process_remark][:process_coverage_id]).group_remit
          group_remit.update!(status: :for_payment)

          format.html { redirect_to process_coverage_approve_path(process_coverage_id: params[:process_remark][:process_coverage_id])}
        elsif params[:process_remark][:process_status] == "Deny"
          format.html { redirect_to process_coverage_deny_path(process_coverage_id: params[:process_remark][:process_coverage_id])}
        else
          format.html { redirect_to process_coverage_url(params[:process_remark][:process_coverage_id]), notice: "Process remark was successfully created." }
          format.json { render :show, status: :created, location: @process_remark }
        end
        # format.html { redirect_back fallback_location:, notice: "Process remark was successfully created." }
        
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
