class ProcessRoutesController < ApplicationController
  before_action :set_process_route, only: %i[ show edit update destroy ]

  # GET /process_routes
  def index
    @process_routes = ProcessRoute.all
  end

  # GET /process_routes/1
  def show
  end

  # GET /process_routes/new
  def new
    @process_route = ProcessRoute.new
  end

  # GET /process_routes/1/edit
  def edit
  end

  # POST /process_routes
  def create
    @process_route = ProcessRoute.new(process_route_params)

    if @process_route.save
      redirect_to @process_route, notice: "Process route was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /process_routes/1
  def update
    if @process_route.update(process_route_params)
      redirect_to @process_route, notice: "Process route was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /process_routes/1
  def destroy
    @process_route.destroy
    redirect_to process_routes_url, notice: "Process route was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_route
      @process_route = ProcessRoute.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def process_route_params
      params.require(:process_route).permit(:name, :department, :description)
    end
end
