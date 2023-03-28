class CoopBranchesController < ApplicationController
  before_action :set_coop_branch, only: %i[ show edit update destroy ]

  # GET /coop_branches or /coop_branches.json
  def index
    @coop_branches = CoopBranch.all
  end

  # GET /coop_branches/1 or /coop_branches/1.json
  def show
  end

  # GET /coop_branches/new
  def new
    @coop_branch = CoopBranch.new
  end

  # GET /coop_branches/1/edit
  def edit
  end

  # POST /coop_branches or /coop_branches.json
  def create
    @coop_branch = CoopBranch.new(coop_branch_params)

    respond_to do |format|
      if @coop_branch.save
        format.html { redirect_to coop_branch_url(@coop_branch), notice: "Coop branch was successfully created." }
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
        format.html { redirect_to coop_branch_url(@coop_branch), notice: "Coop branch was successfully updated." }
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
      format.html { redirect_to coop_branches_url, notice: "Coop branch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coop_branch
      @coop_branch = CoopBranch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def coop_branch_params
      params.require(:coop_branch).permit(:name, :region, :province, :municipality, :barangay, :contact_details, :cooperative_id)
    end
end
