class GroupProposalsController < ApplicationController
  before_action :set_group_proposal, only: %i[ show edit update destroy ]

  # GET /group_proposals
  def index
    @group_proposals = GroupProposal.all
  end

  # GET /group_proposals/1
  def show
  end

  # GET /group_proposals/new
  def new
    @group_proposal = GroupProposal.new
  end

  # GET /group_proposals/1/edit
  def edit
  end

  # POST /group_proposals
  def create
    @group_proposal = GroupProposal.new(group_proposal_params)

    if @group_proposal.save
      redirect_to @group_proposal, notice: "Group proposal was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /group_proposals/1
  def update
    if @group_proposal.update(group_proposal_params)
      redirect_to @group_proposal, notice: "Group proposal was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /group_proposals/1
  def destroy
    @group_proposal.destroy
    redirect_to group_proposals_url, notice: "Group proposal was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_proposal
      @group_proposal = GroupProposal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_proposal_params
      params.require(:group_proposal).permit(:cooperative_id, :plan_id, :plan_unit_id)
    end
end
