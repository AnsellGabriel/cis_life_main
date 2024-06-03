class CoopBranchesController < ApplicationController
  # before_action :authenticate_user!
  # before_action :check_userable_type
  before_action :set_coop_branch, only: %i[ show edit update destroy ]

  # GET /coop_branches or /coop_branches.json
  def index
    if current_user.userable_type == "CoopUser"
      @coop_branches = @cooperative.coop_branches.all
    else
      @coop_branches = CoopBranch.all
    end

    respond_to do |format|
      format.html # render the index view template
    end
  end

  # GET /coop_branches/1 or /coop_branches/1.json
  def show
  end

  # GET /coop_branches/new
  def new
    # @cooperative = Cooperative.find(params[:v])

    if current_user.userable_type == "CoopUser"
      @coop_branch = @cooperative.coop_branches.build
    else
      @coop_branch = CoopBranch.new()
    end
    # default_values
    @prov = @muni = @brgy = []

    # if Rails.env.development?
    #   default_values
    # end
  end

  # GET /coop_branches/1/edit
  def edit
    @prov = GeoProvince.where(geo_region_id: @coop_branch.geo_region_id)
    @muni = GeoMunicipality.where(geo_province_id: @coop_branch.geo_province_id)
    @brgy = GeoBarangay.where(geo_municipality_id: @coop_branch.geo_municipality_id)
  end

  # POST /coop_branches or /coop_branches.json
  def create
    if @cooperative.nil?
      @cooperative = Cooperative.find_by(id: params[:coop_branch][:cooperative_id])
    end
    # @cooperative = Cooperative.find(params[:cooperative_id])
    # @cooperative = Cooperative.find(params[:v])
    @coop_branch = @cooperative.coop_branches.build(coop_branch_params)
    respond_to do |format|
      if @coop_branch.save
        # format.html { redirect_to cooperative_coop_branches_path, notice: "Coop branch was successfully created." }
        format.html { redirect_back fallback_location: @cooperative, notice: "Branch was successfully added." }
        format.json { render :show, status: :created, location: @coop_branch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @coop_branch.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coop_branches/1 or /coop_branches/1.json
  def update

    respond_to do |format|
      if @coop_branch.update(coop_branch_params)
        format.html { redirect_back fallback_location: @cooperative, notice: "Coop branch was successfully updated." }
        format.json { render :show, status: :ok, location: @coop_branch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @coop_branch.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coop_branches/1 or /coop_branches/1.json
  def destroy
    begin
      @coop_branch.destroy
    rescue ActiveRecord::InvalidForeignKey => e
      redirect_to cooperative_path(@cooperative), alert: "Branch cannot be deleted due to dependent records."
      return
    end

    respond_to do |format|
      format.html { redirect_to cooperative_coop_branches_path, notice: "Coop branch was successfully destroyed." }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def set_coop_branch
    # set_cooperative
    # @coop_branch = @cooperative.coop_branches.find(params[:id])
    @coop_branch = CoopBranch.find(params[:id])
    @cooperative = Cooperative.find(@coop_branch.cooperative.id)
  end

  # Only allow a list of trusted parameters through.
  # def coop_branch_params
  #   params.require(:coop_branch).permit(:name, :region, :province, :municipality, :barangay, :contact_details, :cooperative_id)
  # end
  def coop_branch_params
    params.require(:coop_branch).permit(:name, :geo_region_id, :geo_province_id, :geo_municipality_id, :geo_barangay_id, :street, :contact_details, :cooperative_id)
  end

  # def check_userable_type
  #   unless current_user.userable_type == 'CoopUser' || current_user.userable_type == 'Employee'
  #     render file: "#{Rails.root}/public/404.html", status: :not_found
  #   end
  # end

  def default_values
    @geo_region = GeoRegion.all
    @coop_branch.geo_region_id = @geo_region.shuffle.first.id
    @geo_province = GeoProvince.where(geo_region_id: @cooperative.geo_region_id)
    @coop_branch.geo_province_id = @geo_province.shuffle.first.id
    @geo_municipality = GeoMunicipality.where(geo_province_id: @cooperative.geo_province_id)
    @coop_branch.geo_municipality_id = @geo_municipality.shuffle.first.id
    @geo_barangay = GeoBarangay.where(geo_municipality_id: @cooperative.geo_municipality_id)
    @coop_branch.geo_barangay_id = @geo_barangay.shuffle.first.id
    @coop_branch.street = FFaker::Address.neighborhood
    @coop_branch.name = @coop_branch.street
    @coop_branch.contact_details = FFaker::PhoneNumber.phone_number
  end
end
