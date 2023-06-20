class CooperativesController < ApplicationController
  before_action :check_userable_type, except: %i[ selected ]
  before_action :set_cooperative, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ index show edit update destroy ]

  # GET /cooperatives or /cooperatives.json
  def index
    @cooperatives = Cooperative.all
  end

  # GET /cooperatives/1 or /cooperatives/1.json
  def show
  end

  # GET /cooperatives/new
  def new
    @cooperative = Cooperative.new
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
      params.require(:cooperative).permit(:coop_type_id, :geo_region_id, :geo_province_id, :geo_municipality_id, :geo_barangay_id, :street, :name, :description, :registration_no, :tin, :acronym, :contact_no, :email)
    end
end
