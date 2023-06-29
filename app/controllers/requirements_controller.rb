class RequirementsController < ApplicationController
  before_action :set_requirement, only: %i[ show edit update destroy ]

  # GET /requirements
  def index
    @requirements = Requirement.all
  end

  # GET /requirements/1
  def show
  end

  # GET /requirements/new
  def new
    @requirement = Requirement.new
  end

  # GET /requirements/1/edit
  def edit
  end

  # POST /requirements
  def create
    @requirement = Requirement.new(requirement_params)

    if @requirement.save
      redirect_to @requirement, notice: "Requirement was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /requirements/1
  def update
    if @requirement.update(requirement_params)
      redirect_to @requirement, notice: "Requirement was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /requirements/1
  def destroy
    @requirement.destroy
    redirect_to requirements_url, notice: "Requirement was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_requirement
      @requirement = Requirement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def requirement_params
      params.require(:requirement).permit(:name, :description)
    end
end
