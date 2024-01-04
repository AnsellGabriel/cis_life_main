class UnitBenefitsController < ApplicationController
  before_action :set_unit_benefit, only: %i[ show edit update destroy ]

  # GET /unit_benefits
  def index
    @unit_benefits = UnitBenefit.all
  end

  # GET /unit_benefits/1
  def show
  end

  # GET /unit_benefits/new
  def new
    @unit_benefit = UnitBenefit.new
  end

  # GET /unit_benefits/1/edit
  def edit
  end

  # POST /unit_benefits
  def create
    @unit_benefit = UnitBenefit.new(unit_benefit_params)

    if @unit_benefit.save
      redirect_to @unit_benefit, notice: "Unit benefit was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /unit_benefits/1
  def update
    if @unit_benefit.update(unit_benefit_params)
      redirect_to @unit_benefit, notice: "Unit benefit was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /unit_benefits/1
  def destroy
    @unit_benefit.destroy
    redirect_to unit_benefits_url, notice: "Unit benefit was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_unit_benefit
    @unit_benefit = UnitBenefit.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def unit_benefit_params
    params.require(:unit_benefit).permit(:plan_unit_id, :benefit_id, :coverage_amount)
  end
end
