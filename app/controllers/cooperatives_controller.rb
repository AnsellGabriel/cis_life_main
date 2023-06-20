class CooperativesController < ApplicationController
  before_action :set_cooperative, only: %i[ show edit update destroy ]

  # GET /cooperatives
  def index
    @cooperatives = Cooperative.all
  end

  # GET /cooperatives/1
  def show
  end

  # GET /cooperatives/new
  def new
    @cooperative = Cooperative.new
  end

  # GET /cooperatives/1/edit
  def edit
  end

  # POST /cooperatives
  def create
    @cooperative = Cooperative.new(cooperative_params)

    if @cooperative.save
      redirect_to @cooperative, notice: "Cooperative was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cooperatives/1
  def update
    if @cooperative.update(cooperative_params)
      redirect_to @cooperative, notice: "Cooperative was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /cooperatives/1
  def destroy
    @cooperative.destroy
    redirect_to cooperatives_url, notice: "Cooperative was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cooperative
      @cooperative = Cooperative.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cooperative_params
      params.require(:cooperative).permit(:coop_type_id, :geo_region_id, :geo_province_id, :geo_municipality_id, :geo_barangay_id, :street, :name, :description, :registration_no, :tin, :acronym, :contact_no, :email)
    end
end
