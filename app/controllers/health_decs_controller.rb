class HealthDecsController < ApplicationController
  before_action :set_health_dec, only: %i[ show edit update destroy ]

  # GET /health_decs
  def index
    @health_decs = HealthDec.all
  end

  # GET /health_decs/1
  def show
  end

  # GET /health_decs/new
  def new
    @health_dec = HealthDec.new
  end

  # GET /health_decs/1/edit
  def edit
  end

  # POST /health_decs
  def create
    @health_dec = HealthDec.new(health_dec_params)

    if @health_dec.save
      redirect_to @health_dec, notice: "Health dec was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /health_decs/1
  def update
    if @health_dec.update(health_dec_params)
      redirect_to @health_dec, notice: "Health dec was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /health_decs/1
  def destroy
    @health_dec.destroy
    redirect_to health_decs_url, notice: "Health dec was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_health_dec
      @health_dec = HealthDec.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def health_dec_params
      params.require(:health_dec).permit(:question, :active, :with_details, :valid_answer, :question_sort)
    end
end
