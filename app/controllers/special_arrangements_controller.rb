class SpecialArrangementsController < ApplicationController
  before_action :set_special_arrangement, only: %i[ show edit update destroy ]

  # GET /special_arrangements
  def index
    @special_arrangements = SpecialArrangement.all
  end

  # GET /special_arrangements/1
  def show
  end

  # GET /special_arrangements/new
  def new
    # @special_arrangement = SpecialArrangement.new
    @agreement = Agreement.find(params[:v])
    @special_arrangement = @agreement.special_arrangements.build
  end

  # GET /special_arrangements/1/edit
  def edit
  end

  # POST /special_arrangements
  def create
    @agreement = Agreement.find(params[:v])
    @special_arrangement = @agreement.special_arrangements.build(special_arrangement_params)
    # @special_arrangement = SpecialArrangement.new(special_arrangement_params)

    if @special_arrangement.save
      redirect_back fallback_location: @agreement, notice: "Special arrangement was successfully created."
    else
      render :new, status: :unprocessable_entity
      format.turbo_stream { render :form_update, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /special_arrangements/1
  def update
    if @special_arrangement.update(special_arrangement_params)
      redirect_back fallback_location: @agreement, notice: "Special arrangement was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
      format.turbo_stream { render :form_update, status: :unprocessable_entity }
    end
  end

  # DELETE /special_arrangements/1
  def destroy
    @special_arrangement.destroy
    redirect_to special_arrangements_url, notice: "Special arrangement was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_special_arrangement
      @special_arrangement = SpecialArrangement.find(params[:id])
      @agreement = @special_arrangement.agreement
    end

    # Only allow a list of trusted parameters through.
    def special_arrangement_params
      params.require(:special_arrangement).permit(:agreement_id, :arrangement)
    end
end
