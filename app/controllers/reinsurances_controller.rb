class ReinsurancesController < ApplicationController
  before_action :set_reinsurance, only: %i[ show edit update destroy ]

  # GET /reinsurances
  def index
    @reinsurances = Reinsurance.all
  end

  # GET /reinsurances/1
  def show
  end

  # GET /reinsurances/new
  def new
    @reinsurance = Reinsurance.new
  end

  # GET /reinsurances/1/edit
  def edit
  end

  # POST /reinsurances
  def create
    @reinsurance = Reinsurance.new(reinsurance_params)

    if @reinsurance.save
      redirect_to @reinsurance, notice: "Reinsurance was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reinsurances/1
  def update
    if @reinsurance.update(reinsurance_params)
      redirect_to @reinsurance, notice: "Reinsurance was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reinsurances/1
  def destroy
    @reinsurance.destroy
    redirect_to reinsurances_url, notice: "Reinsurance was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reinsurance
      @reinsurance = Reinsurance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reinsurance_params
      params.require(:reinsurance).permit(:date_from, :date_to, :ri_total_amount, :ri_total_prem)
    end
end
