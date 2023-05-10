class CoopBranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_coop_branch, only: %i[ show edit update destroy ]

  # GET /coop_branches or /coop_branches.json
  def index
    @cooperative = Cooperative.find(params[:cooperative_id])
    @coop_branches = @cooperative.coop_branches.all
  
    respond_to do |format|
      format.html # render the index view template
    end
  end

  # GET /coop_branches/1 or /coop_branches/1.json
  def show
  end

  # GET /coop_branches/new
  def new
    @cooperative = Cooperative.find(params[:cooperative_id])
    @coop_branch = @cooperative.coop_branches.build
  end

  # GET /coop_branches/1/edit
  def edit
  end

  # POST /coop_branches or /coop_branches.json
  def create
    @cooperative = Cooperative.find(params[:cooperative_id])
    @coop_branch = @cooperative.coop_branches.build(coop_branch_params)

    respond_to do |format|
      if @coop_branch.save
        format.html { redirect_to cooperative_coop_branches_path, notice: "Coop branch was successfully created." }
        format.json { render :show, status: :created, location: @coop_branch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @coop_branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coop_branches/1 or /coop_branches/1.json
  def update
    respond_to do |format|
      if @coop_branch.update(coop_branch_params)
        format.html { redirect_to cooperative_coop_branch_path, notice: "Coop branch was successfully updated." }
        format.json { render :show, status: :ok, location: @coop_branch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @coop_branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coop_branches/1 or /coop_branches/1.json
  def destroy
    @coop_branch.destroy

    respond_to do |format|
      format.html { redirect_to cooperative_coop_branches_path, notice: "Coop branch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coop_branch
      @cooperative = Cooperative.find(params[:cooperative_id])
      @coop_branch = @cooperative.coop_branches.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def coop_branch_params
      params.require(:coop_branch).permit(:name, :region, :province, :municipality, :barangay, :contact_details, :cooperative_id)
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
