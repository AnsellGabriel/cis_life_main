class CoopsController < ApplicationController
  before_action :set_coop, only: %i[ show edit update destroy ]

  # GET /coops or /coops.json
  def index
    @coops = Coop.all
  end

  # GET /coops/1 or /coops/1.json
  def show
  end

  # GET /coops/new
  def new
    @coop = Coop.new(last_name: FFaker::Name.last_name, first_name: FFaker::Name.first_name, middle_name: FFaker::Name.last_name, mobile_number: FFaker::PhoneNumber, designation: FFaker::String)
    
    # new instance of the "User" class associated with the "Coop" instance.
    @coop.build_user
  end

  # GET /coops/1/edit
  def edit
  end

  # POST /coops or /coops.json
  def create
    @coop = Coop.new(coop_params)

    respond_to do |format|
      if @coop.save
        format.html { redirect_to unauthenticated_root_path, notice: "Coop was successfully created." }
        format.json { render :show, status: :created, location: @coop }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @coop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coops/1 or /coops/1.json
  def update
    respond_to do |format|
      if @coop.update(coop_params)
        format.html { redirect_to coop_url(@coop), notice: "Coop was successfully updated." }
        format.json { render :show, status: :ok, location: @coop }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @coop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coops/1 or /coops/1.json
  def destroy
    @coop.destroy

    respond_to do |format|
      format.html { redirect_to coops_url, notice: "Coop was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coop
      @coop = Coop.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def coop_params
      params.require(:coop).permit(:last_name, :first_name, :middle_name, :birthdate, :mobile_number, :designation, :cooperative_id, :coop_branch_id, user_attributes: [:email, :password, :password_confirmation, :userable_type, :userable_id])
    end
end
