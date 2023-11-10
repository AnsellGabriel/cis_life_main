class CoopTypesController < ApplicationController
  before_action :set_coop_type, only: %i[ show edit update destroy ]

  # GET /coop_types
  def index
    @coop_types = CoopType.all
  end

  # GET /coop_types/1
  def show
  end

  # GET /coop_types/new
  def new
    @coop_type = CoopType.new
  end

  # GET /coop_types/1/edit
  def edit
  end

  # POST /coop_types
  def create
    @coop_type = CoopType.new(coop_type_params)

    if @coop_type.save
      redirect_to @coop_type, notice: "Coop type was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /coop_types/1
  def update
    if @coop_type.update(coop_type_params)
      redirect_to @coop_type, notice: "Coop type was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /coop_types/1
  def destroy
    @coop_type.destroy
    redirect_to coop_types_url, notice: "Coop type was successfully destroyed."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_coop_type
    @coop_type = CoopType.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def coop_type_params
    params.require(:coop_type).permit(:name, :description)
  end
end
