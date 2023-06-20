class GeoMunicipalitiesController < ApplicationController
  before_action :set_geo_municipality, only: %i[ show edit update destroy ]

  # GET /geo_municipalities
  def index
    @geo_municipalities = GeoMunicipality.all
  end

  # GET /geo_municipalities/1
  def show
  end

  # GET /geo_municipalities/new
  def new
    @geo_municipality = GeoMunicipality.new
  end

  # GET /geo_municipalities/1/edit
  def edit
  end

  # POST /geo_municipalities
  def create
    @geo_municipality = GeoMunicipality.new(geo_municipality_params)

    if @geo_municipality.save
      redirect_to @geo_municipality, notice: "Geo municipality was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /geo_municipalities/1
  def update
    if @geo_municipality.update(geo_municipality_params)
      redirect_to @geo_municipality, notice: "Geo municipality was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /geo_municipalities/1
  def destroy
    @geo_municipality.destroy
    redirect_to geo_municipalities_url, notice: "Geo municipality was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_geo_municipality
      @geo_municipality = GeoMunicipality.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def geo_municipality_params
      params.require(:geo_municipality).permit(:geo_region_id, :geo_provice_id)
    end
end
