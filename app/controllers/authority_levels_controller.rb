class AuthorityLevelsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_employee
  before_action :set_authority_level, only: %i[ show edit update destroy ]

  # GET /authority_levels
  def index
    @authority_levels = AuthorityLevel.all
  end

  # GET /authority_levels/1
  def show
  end

  # GET /authority_levels/new
  def new
    @authority_level = AuthorityLevel.new
  end

  # GET /authority_levels/1/edit
  def edit
  end

  # POST /authority_levels
  def create
    @authority_level = AuthorityLevel.new(authority_level_params)

    if @authority_level.save
      redirect_to new_user_level_path,  notice: "Authority level was successfully created."
      # redirect_to @authority_level, notice: "Authority level was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /authority_levels/1
  def update
    if @authority_level.update(authority_level_params)
      # redirect_to @authority_level, notice: "Authority level was successfully updated."
      redirect_to new_user_level_path, notice: "Authority level was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /authority_levels/1
  def destroy
    @authority_level.destroy
    edirect_to new_user_level_path, notice: "Authority level was successfully destroyed."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_authority_level
    @authority_level = AuthorityLevel.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def authority_level_params
    params.require(:authority_level).permit(:name, :maxAmount, :entry_type)
  end
end
