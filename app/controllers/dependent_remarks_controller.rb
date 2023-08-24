class DependentRemarksController < ApplicationController
  before_action :set_dependent_remark, only: %i[ show edit update destroy ]
  before_action :set_dependent, only: %i[ new index ]

  # GET /dependent_remarks
  def index
    @remarks = @dependent.dependent_remarks
  end

  # GET /dependent_remarks/1
  def show
  end

  # GET /dependent_remarks/new
  def new
    @dependent_remark = @dependent.dependent_remarks.new
    @rem_status = params[:status]
    @group_remit = GroupRemit.find(params[:group_remit_id])
    @batch = @dependent.batch
    @process_coverage = ProcessCoverage.find(params[:process_coverage_id])
  end

  # GET /dependent_remarks/1/edit
  def edit
  end

  # POST /dependent_remarks
  def create
    @dependent = BatchDependent.find(params[:dependent_remark][:batch_dependent_id])
    @dependent_remark = @dependent.dependent_remarks.build(dependent_remark_params)

    if @dependent_remark.save!
      @dependent.update_insurance_status(@dependent_remark.status)
      redirect_to dependent_remarks_path(
        batch_dependent_id: @dependent.id, 
        group_remit_id: params[:dependent_remark][:group_remit_id], 
        batch_id: @dependent.batch, 
        process_coverage_id: params[:dependent_remark][:process_coverage_id]
      ), 
        notice: "Dependent remark was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /dependent_remarks/1
  def update
    if @dependent_remark.update(dependent_remark_params)
      redirect_to @dependent_remark, notice: "Dependent remark was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /dependent_remarks/1
  def destroy
    @dependent_remark.destroy
    redirect_to dependent_remarks_url, notice: "Dependent remark was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dependent_remark
      @dependent_remark = DependentRemark.find(params[:id])
    end

    def set_dependent
      @dependent = BatchDependent.find(params[:batch_dependent_id])
    end

    # Only allow a list of trusted parameters through.
    def dependent_remark_params
      params.require(:dependent_remark).permit(:user_id, :batch_dependent_id, :remark, :status, :group_remit_id, :process_coverage_id)
    end
end
