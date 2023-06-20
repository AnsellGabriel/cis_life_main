class GeoBarangaysController < ApplicationController
  before_action :set_geo_barangay, only: %i[ show edit update destroy ]

  # GET /geo_barangays
  def index
    @geo_barangays = GeoBarangay.all
  end

  # GET /geo_barangays/1
  def show
  end

  # GET /geo_barangays/new
  def new
    @geo_barangay = GeoBarangay.new
  end

  # GET /geo_barangays/1/edit
  def edit
  end

  # POST /geo_barangays
  def create
    @geo_barangay = GeoBarangay.new(geo_barangay_params)

    if @geo_barangay.save
      redirect_to @geo_barangay, notice: "Geo barangay was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /geo_barangays/1
  def update
    if @geo_barangay.update(geo_barangay_params)
      redirect_to @geo_barangay, notice: "Geo barangay was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /geo_barangays/1
  def destroy
    @geo_barangay.destroy
    redirect_to geo_barangays_url, notice: "Geo barangay was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_geo_barangay
      @geo_barangay = GeoBarangay.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def geo_barangay_params
      params.require(:geo_barangay).permit(:geo_region_id, :geo_province_id, :geo_municipality_id, :psgc_code)
    end
end
