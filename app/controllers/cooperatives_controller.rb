class CooperativesController < ApplicationController
  # before_action :check_userable_type, except: %i[ selected ]
  before_action :set_cooperative, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ index show edit update destroy ]

  # GET /cooperatives or /cooperatives.json
  def index
    @cooperatives = Cooperative.all
  end

  # GET /cooperatives/1 or /cooperatives/1.json
  def show
    @coop_branches = CoopBranch.where(cooperative: @cooperative)
  end

  # GET /cooperatives/new
  def new
    @cooperative = Cooperative.new
    default_values
  end
  def default_values 
    @geo_region = GeoRegion.all
    @coop_type = CoopType.all
    @cooperative.geo_region_id = @geo_region.shuffle.first.id
    @geo_province = GeoProvince.where(geo_region_id: @cooperative.geo_region_id)
    @cooperative.geo_province_id = @geo_province.shuffle.first.id
    @geo_municipality = GeoMunicipality.where(geo_province_id: @cooperative.geo_province_id)
    @cooperative.geo_municipality_id = @geo_municipality.shuffle.first.id
    @geo_barangay = GeoBarangay.where(geo_municipality_id: @cooperative.geo_municipality_id)
    @cooperative.geo_barangay_id = @geo_barangay.shuffle.first.id
    @cooperative.street = FFaker::Address.neighborhood + ' ' + FFaker::Address.city_suffix
    @coop_typ = @coop_type.shuffle.first
    @cooperative.coop_type_id = @coop_typ.id
    @cooperative.name = FFaker::Venue.name + ' ' + @coop_typ.name
    @cooperative.description = FFaker::HipsterIpsum.paragraph
    first_letters = @cooperative.name.split.map { |word| word[0] }
    @cooperative.acronym = first_letters.join
    @cooperative.email = "support@" + first_letters.join + '.com'
    @cooperative.contact_details = FFaker::PhoneNumber.phone_number
    @cooperative.registration_no = FFaker::PhoneNumber.phone_number
    @cooperative.tin = FFaker::PhoneNumber.phone_number
  end
  # GET /cooperatives/1/edit
  def edit
  end

  # POST /cooperatives or /cooperatives.json
  def create
    @cooperative = Cooperative.new(cooperative_params)

    respond_to do |format|
      if @cooperative.save
        format.html { redirect_to cooperative_url(@cooperative), notice: "Account created successfully. Please wait for the admin to approve your account." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cooperatives/1 or /cooperatives/1.json
  def update
    respond_to do |format|
      if @cooperative.update(cooperative_params)
        format.html { redirect_to cooperative_url(@cooperative), notice: "Cooperative was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cooperatives/1 or /cooperatives/1.json
  def destroy
    @cooperative.destroy

    respond_to do |format|
      format.html { redirect_to cooperatives_url, notice: "Cooperative was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def selected
    @target = params[:target]
    @coop_branches = CoopBranch.where(cooperative_id: params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end

  def branches
    @target = params[:target]
    @branches = Cooperative.find(params[:id]).coop_branches
    format.turbo_stream # render the index.turbo_stream.erb template
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cooperative
      @cooperative = Cooperative.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cooperative_params
      # params.require(:cooperative).permit(:coop_type_id, :geo_region_id, :geo_province_id, :geo_municipality_id, :geo_barangay_id, :street, :name, :description, :registration_no, :tin, :acronym, :contact_no, :email)
      params.require(:cooperative).permit(:coop_type_id, :geo_region_id, :geo_province_id, :geo_municipality_id, :geo_barangay_id, :street, :name, :description, :registration_no, :tin, :acronym, :contact_details, :email,
        coop_branches_params: [:id, :name, :geo_region_id, :geo_province_id, :geo_municipality_id, :geo_barangay_id, :street, :contact_details])
    end
end
