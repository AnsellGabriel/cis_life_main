class EmployeeTeamsController < ApplicationController
  before_action :set_employee_team, only: %i[ show edit update destroy ]

  # GET /employee_teams
  def index
    @employee_teams = EmployeeTeam.all
  end

  # GET /employee_teams/1
  def show
  end

  # GET /employee_teams/new
  def new
    @employee_team = EmployeeTeam.new
  end

  # GET /employee_teams/1/edit
  def edit
  end

  # POST /employee_teams
  def create
    @employee_team = EmployeeTeam.new(employee_team_params)

    if @employee_team.save
      redirect_to @employee_team, notice: "Employee team was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employee_teams/1
  def update
    if @employee_team.update(employee_team_params)
      redirect_to @employee_team, notice: "Employee team was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /employee_teams/1
  def destroy
    @employee_team.destroy
    redirect_to employee_teams_url, notice: "Employee team was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_team
      @employee_team = EmployeeTeam.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employee_team_params
      params.require(:employee_team).permit(:employee_id, :team_id, :head)
    end
end
