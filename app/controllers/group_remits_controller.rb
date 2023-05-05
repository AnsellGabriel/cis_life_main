class GroupRemitsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_group_remit, only: %i[show edit update destroy]
  before_action :set_cooperative, only: %i[new edit update show index create]
  before_action :set_members, only: %i[new create edit update]

  def index
    @group_remits = @cooperative.group_remits.order(id: :desc)
  end

  def show
    # ! test code
    # b_active = mem_age <= proposal.old_max_age && mem_age >= proposal.old_min_age ? true : false
    
    # terms = (expire.year * 12 + expire.month) - (effect.year * 12 + effect.month)
    # pro_insured = proposal.proposal_insureds.where(insured_type: 1).sum(:total_prem)
    # final_prem = (pro_insured / 12) * terms
    # coop_sf = (final_prem * proposal.coop_sf)
    # agent_sf = (final_prem * proposal.agent_sf)
    # ! end test

    # filter members based on last name, first name, middle name
    # @members = f_members.where("last_name LIKE ? AND first_name LIKE ? AND middle_name LIKE ?", "%#{params[:last_name_filter]}%", "%#{params[:first_name_filter]}%", "%#{params[:middle_name_filter]}%")

    @batches = @group_remit.batches.order(created_at: :desc)
    @pagy, @batches = pagy(@batches, items: 10)

    # premium and commission totals
    # byebug
    batch_dependent_premiums = @group_remit.batches.joins(:batch_dependents).where(batch_dependents: {is_dependent: true}).sum('batch_dependents.premium')
    @gross_premium = @group_remit.batches.sum(:premium) + batch_dependent_premiums
    @total_coop_commission = @group_remit.batches.sum(:coop_sf_amount)
    @total_agent_commission = @group_remit.batches.sum(:agent_sf_amount)
    @net_premium = @gross_premium - @total_coop_commission

  end

  def new
    @agreements = @cooperative.agreements
    @group_remit = @cooperative.group_remits.build(name: FFaker::Company.name, description: FFaker::Lorem.paragraph, agreement_id: 1, anniversary_id: 1)
    @batch = @group_remit.batches.build(effectivity_date: FFaker::Time.date, expiry_date: FFaker::Time.date, active: true, coop_sf_amount: 10, agent_sf_amount: 5, status: :recent)
  end

  def create
    @group_remit = @cooperative.group_remits.build(group_remit_params)
    @group_remit.effectivity_date = Date.today

    anniversary = Anniversary.find_by(id: group_remit_params[:anniversary_id]).anniversary_date
    today = Date.today
    terms = (anniversary.year * 12 + anniversary.month) - (today.year * 12 + today.month)

    @group_remit.terms = terms <= 0 ? terms + 12 : terms
    @group_remit.expiry_date = terms <= 0 ? anniversary.next_year : anniversary

    # plan = agreement.plan
    plan = @cooperative.agreements.find_by(id: group_remit_params[:agreement_id]).plan
    @group_remit.name = "#{plan.acronym}-Remittance-#{GroupRemit.last.id + 1}"

    respond_to do |format|
      if @group_remit.save!
        format.html { redirect_to @group_remit, notice: "Group remit was successfully created." }
        format.json { render :show, status: :created, location: @group_remit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group_remit.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group_remit.update(group_remit_params)
        format.html { redirect_to @group_remit, notice: "Group remit was successfully updated." }
        format.json { render :show, status: :ok, location: @group_remit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group_remit.errors, status: :unprocessable_entity }
      end
    end
  end


  private

    def set_group_remit
      @cooperative = current_user.userable.cooperative
      @group_remit = @cooperative.group_remits.find_by(id: params[:id])
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end

    def set_members
      @cooperative = current_user.userable.cooperative
      @coop_members = @cooperative.coop_members
      @members = Member.joins(:coop_members).where(coop_members: { id: @coop_members.ids }).order(:last_name)
    end

    def group_remit_params
      params.require(:group_remit).permit(:name, :description, :agreement_id, :anniversary_id, batches_attributes: [:id, :effectivity_date, :expiry_date, :active, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id, :_destroy, batch_dependents_attributes: [:member_dependent_id, :beneficiary, :_destroy]])
    end

end
