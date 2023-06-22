class HealthDecSubquestionsController < ApplicationController
  before_action :set_health_dec_subquestion, only: %i[ show edit update destroy ]

  # GET /health_dec_subquestions
  def index
    @health_dec_subquestions = HealthDecSubquestion.all
  end

  # GET /health_dec_subquestions/1
  def show
  end

  # GET /health_dec_subquestions/new
  def new
    @health_dec = HealthDec.find(params[:health_dec_id])
    @health_dec_subquestion = @health_dec.health_dec_subquestions.build
  end

  # GET /health_dec_subquestions/1/edit
  def edit
  end

  # POST /health_dec_subquestions
  def create
    @health_dec = HealthDec.find(params[:health_dec_id])
    @health_dec_subquestion = @health_dec.health_dec_subquestions.build(health_dec_subquestion_params)

    if @health_dec_subquestion.save!
      redirect_to @health_dec, notice: "Health dec subquestion was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /health_dec_subquestions/1
  def update
    if @health_dec_subquestion.update(health_dec_subquestion_params)
      redirect_to @health_dec_subquestion, notice: "Health dec subquestion was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /health_dec_subquestions/1
  def destroy
    @health_dec_subquestion.destroy
    redirect_to health_dec_subquestions_url, notice: "Health dec subquestion was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_health_dec_subquestion
      @health_dec_subquestion = HealthDecSubquestion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def health_dec_subquestion_params
      params.require(:health_dec_subquestion).permit(:question, :health_dec_id)
    end
end
