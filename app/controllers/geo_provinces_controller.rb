class GeoProvincesController < ApplicationController
  before_action :set_geo_province, only: %i[ show edit update destroy ]

  # GET /geo_provinces
  def index
    @geo_provinces = GeoProvince.all
  end

  # GET /geo_provinces/1
  def show
  end

  # GET /geo_provinces/new
  def new
    @geo_province = GeoProvince.new
  end

  # GET /geo_provinces/1/edit
  def edit
  end

  # POST /geo_provinces
  def create
    @geo_province = GeoProvince.new(geo_province_params)

    if @geo_province.save
      redirect_to @geo_province, notice: "Geo province was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /geo_provinces/1
  def update
    if @geo_province.update(geo_province_params)
      redirect_to @geo_province, notice: "Geo province was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /geo_provinces/1
  def destroy
    @geo_province.destroy
    redirect_to geo_provinces_url, notice: "Geo province was successfully destroyed."
  end

  def selected
    @target = params[:target]
    @municipalities = GeoMunicipality.where(geo_province_id: params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_geo_province
      @geo_province = GeoProvince.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def geo_province_params
      params.require(:geo_province).permit(:name, :geo_region_id)
    end
end
