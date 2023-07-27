class UserLevelsController < ApplicationController
  before_action :set_user_level, only: %i[ show edit update destroy ]

  # GET /user_levels
  def index
    @user_levels = UserLevel.all
  end

  # GET /user_levels/1
  def show
  end

  # GET /user_levels/new
  def new
    @user_level = UserLevel.new
  end

  # GET /user_levels/1/edit
  def edit
  end

  # POST /user_levels
  def create
    @user_level = UserLevel.new(user_level_params)

    if @user_level.save
      redirect_to @user_level, notice: "User level was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_levels/1
  def update
    if @user_level.update(user_level_params)
      redirect_to @user_level, notice: "User level was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /user_levels/1
  def destroy
    @user_level.destroy
    redirect_to user_levels_url, notice: "User level was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_level
      @user_level = UserLevel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_level_params
      params.require(:user_level).permit(:user_id, :authority_level_id, :active)
    end
end
