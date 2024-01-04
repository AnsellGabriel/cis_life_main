class AgentGroupsController < ApplicationController
  def index
    @agent_groups = AgentGroup.all
  end

  def new
    @agent_group = AgentGroup.new
  end

  def create
    @agent_group = AgentGroup.new(agent_group_params)

    if @agent_group.save
      redirect_to agent_groups_path, notice: "Agent Group created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def agent_group_params
    params.require(:agent_group).permit(:name)
  end
end
