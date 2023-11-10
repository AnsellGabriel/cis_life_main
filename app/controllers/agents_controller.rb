class AgentsController < ApplicationController
  before_action :set_agent, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ index show edit update destroy ]


  # GET /agents or /agents.json
  def index
    @agents = Agent.all
  end

  # GET /agents/1 or /agents/1.json
  def show
  end

  # GET /agents/new
  def new
    @agent = Agent.new(last_name: FFaker::Name.last_name, first_name: FFaker::Name.first_name, middle_name: FFaker::Name.last_name, mobile_number: FFaker::PhoneNumber)

    # new instance of the "User" class associated with the "Agent" instance.
    @agent.build_user
  end

  # GET /agents/1/edit
  def edit
  end

  # POST /agents or /agents.json
  def create
    @agent = Agent.new(agent_params)

    respond_to do |format|
      if @agent.save
        format.html {
          redirect_to unauthenticated_root_path,
          notice: "Account created successfully. Please wait for the admin to approve your account."
        }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /agents/1 or /agents/1.json
  def update
    respond_to do |format|
      if @agent.update(agent_params)
        format.html { redirect_to agent_url(@agent), notice: "Agent was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agents/1 or /agents/1.json
  def destroy
    @agent.destroy

    respond_to do |format|
      format.html { redirect_to agents_url, notice: "Agent was successfully destroyed." }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_agent
    @agent = Agent.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def agent_params
    params.require(:agent).permit(:last_name, :first_name, :middle_name, :birthdate, :mobile_number, :agent_group_id,
user_attributes: [:email, :password, :password_confirmation, :userable_type, :userable_id])
  end
end
