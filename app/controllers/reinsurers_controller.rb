class ReinsurersController < ApplicationController
  before_action :set_reinsurer, only: %i[ show edit update destroy ]

  # GET /reinsurers
  def index
    @reinsurers = Reinsurer.all
  end

  # GET /reinsurers/1
  def show
  end

  # GET /reinsurers/new
  def new
    @reinsurer = Reinsurer.new
  end

  # GET /reinsurers/1/edit
  def edit
  end

  # POST /reinsurers
  def create
    @reinsurer = Reinsurer.new(reinsurer_params)

    if @reinsurer.save
      redirect_to @reinsurer, notice: "Reinsurer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reinsurers/1
  def update
    if @reinsurer.update(reinsurer_params)
      redirect_to @reinsurer, notice: "Reinsurer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reinsurers/1
  def destroy
    @reinsurer.destroy
    redirect_to reinsurers_url, notice: "Reinsurer was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reinsurer
      @reinsurer = Reinsurer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reinsurer_params
      params.require(:reinsurer).permit(:name, :short_name, :address, :contact_no)
    end
end
