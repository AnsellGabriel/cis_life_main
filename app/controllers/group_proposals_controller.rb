class GroupProposalsController < ApplicationController
  before_action :set_group_proposal, only: %i[ show edit update destroy ]

  # GET /group_proposals
  def index
    @group_proposals = GroupProposal.all
  end

  # GET /group_proposals/1
  def show
    @koopamilya_features = KoopamilyaAb.all
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

    count = Agreement.joins(:plan).where(plan: {acronym: @group_proposal.plan.acronym}).count
    
    ctr = count == 0 ? count + 1 : count
    respond_to do |format|
        
      # @agreement = @group_proposal.build_agreement(
      #   agent_id: 1, # change value to actual agent_id
      #   moa_no: "#{@group_proposal.plan.acronym}-#{@group_proposal.cooperative.acronym}-#{ctr}",
      #   entry_age_from: @group_proposal.plan.entry_age_from,
      #   entry_age_to: @group_proposal.plan.entry_age_to,
      #   exit_age: @group_proposal.plan.exit_age,
      #   contestability: 12,
      #   minimum_participation: @group_proposal.plan.min_participation,
      #   # @agreement.proposal_id = @group_proposal.id     # default
      #   nel: 25000,      # default value
      #   nml: 2000000,    # default value
      #   coop_sf: 10 ,    # change this value
      #   agent_sf: 10   # change this value
      # )
      # @agreement_benefits = @agreement.agreement_benefits.build(
      #   # proposal_id: @group_proposal.id,
      #   name: "Principal",
      #   plan: @group_proposal.plan,
      #   min_age: @agreement.entry_age_from,
      #   max_age: @agreement.entry_age_to,
      #   insured_type: 1,
      #   exit_age: @agreement.exit_age
      # )      
              
      # prem = @group_proposal.plan_unit.total_prem / @group_proposal.plan_unit.unit_benefits.count
      # @group_proposal.plan_unit.unit_benefits.each do |ub|
      #   @agreement_benefits.product_benefits.build(
      #     coverage_amount: ub.coverage_amount,
      #     benefit: ub.benefit,
      #     premium: prem
      #   )
      # end
      if GroupProposal.where(cooperative: @group_proposal.cooperative, plan: @group_proposal.plan).exists?
        format.html { redirect_to new_group_proposal_path, alert: "Cooperative and Plan selected already exists." }
      else

        @group_proposal.create_agreement(ctr.to_s.rjust(4, '0'))
  
        if @group_proposal.save
          format.html { redirect_to @group_proposal, notice: "Group proposal was successfully created" }
        
          # @agreement = Agreement.find_or_initialize_by(cooperative: @group_proposal.cooperative, plan: @group_proposal.plan)
          # if @agreement.save!
            
          #   format.html { redirect_to @agreement, notice: "#{@agreement.plan} agreement was successfully created." }
          # else
          # end
        else
         format.html { render :new, status: :unprocessable_entity }
        end
      end

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
