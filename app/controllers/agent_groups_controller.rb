class AgentGroupsController < ApplicationController
  before_action :set_agent_group, only: %i[ show edit update destroy ]

  # GET /agent_groups or /agent_groups.json
  def index
    @agent_groups = AgentGroup.all
  end

  # GET /agent_groups/1 or /agent_groups/1.json
  def show
  end

  # GET /agent_groups/new
  def new
    @agent_group = AgentGroup.new
  end

  # GET /agent_groups/1/edit
  def edit
  end

  # POST /agent_groups or /agent_groups.json
  def create
    @agent_group = AgentGroup.new(agent_group_params)

    respond_to do |format|
      if @agent_group.save
        format.html { redirect_to agent_group_url(@agent_group), notice: "Agent group was successfully created." }
        format.json { render :show, status: :created, location: @agent_group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @agent_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /agent_groups/1 or /agent_groups/1.json
  def update
    respond_to do |format|
      if @agent_group.update(agent_group_params)
        format.html { redirect_to agent_group_url(@agent_group), notice: "Agent group was successfully updated." }
        format.json { render :show, status: :ok, location: @agent_group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @agent_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agent_groups/1 or /agent_groups/1.json
  def destroy
    @agent_group.destroy

    respond_to do |format|
      format.html { redirect_to agent_groups_url, notice: "Agent group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent_group
      @agent_group = AgentGroup.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def agent_group_params
      params.require(:agent_group).permit(:name, :description)
    end
end
