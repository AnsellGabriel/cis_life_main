class UnderwritingRoutesController < ApplicationController
  before_action :set_underwriting_route, only: %i[ show edit update destroy ]

  # GET /underwriting_routes
  def index
    @underwriting_routes = UnderwritingRoute.all
  end

  # GET /underwriting_routes/1
  def show
  end

  # GET /underwriting_routes/new
  def new
    @underwriting_route = UnderwritingRoute.new
  end

  # GET /underwriting_routes/1/edit
  def edit
  end

  # POST /underwriting_routes
  def create
    @underwriting_route = UnderwritingRoute.new(underwriting_route_params)

    if @underwriting_route.save
      redirect_to @underwriting_route, notice: "Underwriting route was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /underwriting_routes/1
  def update
    if @underwriting_route.update(underwriting_route_params)
      redirect_to @underwriting_route, notice: "Underwriting route was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /underwriting_routes/1
  def destroy
    @underwriting_route.destroy
    redirect_to underwriting_routes_url, notice: "Underwriting route was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_underwriting_route
      @underwriting_route = UnderwritingRoute.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def underwriting_route_params
      params.require(:underwriting_route).permit(:name, :description)
    end
end
