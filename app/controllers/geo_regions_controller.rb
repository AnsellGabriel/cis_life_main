class GeoRegionsController < ApplicationController
  before_action :set_geo_region, only: %i[ show edit update destroy ]

  # GET /geo_regions
  def index
    @geo_regions = GeoRegion.all
  end

  # GET /geo_regions/1
  def show
  end

  # GET /geo_regions/new
  def new
    @geo_region = GeoRegion.new
  end

  # GET /geo_regions/1/edit
  def edit
  end

  # POST /geo_regions
  def create
    @geo_region = GeoRegion.new(geo_region_params)

    if @geo_region.save
      # redirect_to @geo_region, notice: "Geo region was successfully created."
      redirect_to geo_regions_path, notice: "Geo region was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /geo_regions/1
  def update
    if @geo_region.update(geo_region_params)
      # redirect_to @geo_region, notice: "Geo region was successfully updated."
      redirect_to geo_regions_path, notice: "Geo region was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /geo_regions/1
  def destroy
    @geo_region.destroy
    redirect_to geo_regions_url, notice: "Geo region was successfully destroyed."
  end

  def selected
    @target = params[:target]
    @provinces = GeoProvince.where(geo_region_id: params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_geo_region
    @geo_region = GeoRegion.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def geo_region_params
    params.require(:geo_region).permit(:name)
  end
end
