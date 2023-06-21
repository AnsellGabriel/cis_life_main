class ProcessCoveragesController < ApplicationController
  before_action :set_process_coverage, only: %i[ show edit update destroy ]

  # GET /process_coverages
  def index
    @process_coverages = ProcessCoverage.all
  end

  # GET /process_coverages/1
  def show
  end

  # GET /process_coverages/new
  def new
    @process_coverage = ProcessCoverage.new
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
