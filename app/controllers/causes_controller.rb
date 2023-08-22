class CausesController < ApplicationController
  before_action :set_cause, only: %i[ show edit update destroy ]

  # GET /causes
  def index
    @causes = Cause.all
  end

  # GET /causes/1
  def show
  end

  # GET /causes/new
  def new
    @cause = Cause.new
  end

  # GET /causes/1/edit
  def edit
  end

  # POST /causes
  def create
    @cause = Cause.new(cause_params)

    if @cause.save
      redirect_to @cause, notice: "Cause was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /causes/1
  def update
    if @cause.update(cause_params)
      redirect_to @cause, notice: "Cause was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /causes/1
  def destroy
    @cause.destroy
    redirect_to causes_url, notice: "Cause was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cause
      @cause = Cause.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def claim_benefit_params
      params.require(:claim_benefit).permit(:name, :description)
    end
end