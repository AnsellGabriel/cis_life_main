class PlanUnitsController < ApplicationController
  before_action :set_plan_unit, only: %i[ show edit update destroy ]

  # GET /plan_units
  def index
    @plan_units = PlanUnit.all
  end

  # GET /plan_units/1
  def show
  end

  # GET /plan_units/new
  def new
    @plan_unit = PlanUnit.new
  end

  # GET /plan_units/1/edit
  def edit
  end

  # POST /plan_units
  def create
    @plan_unit = PlanUnit.new(plan_unit_params)

    if @plan_unit.save
      redirect_to @plan_unit, notice: "Plan unit was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /plan_units/1
  def update
    if @plan_unit.update(plan_unit_params)
      redirect_to @plan_unit, notice: "Plan unit was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /plan_units/1
  def destroy
    @plan_unit.destroy
    redirect_to plan_units_url, notice: "Plan unit was successfully destroyed.", status: :see_other
  end

  def find_units
    @plan_unit = PlanUnit.find_by(id: params[:id])
    
    respond_to do |format|
      format.turbo_stream
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan_unit
      @plan_unit = PlanUnit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def plan_unit_params
      params.require(:plan_unit).permit(:plan_id, :name, :total_prem, unit_benefits_attributes: [:id, :benefit_id, :coverage_amount, :_destroy])
    end
end
