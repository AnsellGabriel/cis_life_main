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
    @process_remark = ProcessRemark.new
  end

  # GET /process_remarks/1/edit
  def edit
  end

  # POST /process_remarks
  def create
    @process_remark = ProcessRemark.new(process_remark_params)

    if @process_remark.save
      redirect_to @process_remark, notice: "Process remark was successfully created."
    else
      render :new, status: :unprocessable_entity
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
