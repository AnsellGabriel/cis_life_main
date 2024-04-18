class AgentGroupsController < ApplicationController
  before_action :set_agent_group, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ index show edit update destroy ]

  def index
    @agent_groups = AgentGroup.all
  end

  def new
    @agent_group = AgentGroup.new
  end

  def show
    @agents = @agent_group.agents
  end

  def edit

  end

  def create
    @agent_group = AgentGroup.new(agent_group_params)

    if @agent_group.save
      redirect_to agent_groups_path, notice: "Agent Group created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @agent_group.update(agent_group_params)
        format.html { redirect_to agent_groups_path, notice: "Agent Group was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_agent_group
    @agent_group = AgentGroup.find(params[:id])
  end

  def agent_group_params
    params.require(:agent_group).permit(:name, :description)
  end
end
