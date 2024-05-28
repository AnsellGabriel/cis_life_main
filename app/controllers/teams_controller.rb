class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]

  # GET /teams
  def index
    @teams = Team.all
  end

  # GET /teams/1
  def show
    @f = params[:f] if params[:f].present?
    @agreements = @team.emp_agreements.where(active: true)

    @pagy_agree, @filtered_agreements = pagy(@agreements, items: 5, link_extra: 'data-turbo-frame="pagination"')
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to @team, notice: "Team was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def selected
    @target = params[:target]
    @emp_ids = EmployeeTeam.where(team_id: params[:id], head: false).pluck(:employee_id)
    @employees = Employee.where(id: @emp_ids)
    respond_to do |format|
      format.turbo_stream
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      redirect_to @team, notice: "Team was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    redirect_to teams_url, notice: "Team was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:name, :description)
    end
end
