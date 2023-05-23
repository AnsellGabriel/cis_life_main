class AgentGroupsController < ApplicationController
  before_action :set_agent_group, only: %i[ show edit update destroy ]

  # GET /agent_groups
  def index
    @agent_groups = AgentGroup.all
  end

  # GET /agent_groups/1
  def show
  end

  # GET /agent_groups/new
  def new
    @agent_group = AgentGroup.new
  end

  # GET /agent_groups/1/edit
  def edit
  end

  # POST /agent_groups
  def create
    @agent_group = AgentGroup.new(agent_group_params)

    if @agent_group.save
      redirect_to @agent_group, notice: "Agent group was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /agent_groups/1
  def update
    if @agent_group.update(agent_group_params)
      redirect_to @agent_group, notice: "Agent group was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /agent_groups/1
  def destroy
    @agent_group.destroy
    redirect_to agent_groups_url, notice: "Agent group was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent_group
      @agent_group = AgentGroup.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def agent_group_params
      params.fetch(:agent_group, {})
    end
end
