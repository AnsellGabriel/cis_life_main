class GroupRemitsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type
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
    @agreement = @group_remit.agreement
    @batches_container = @group_remit.batches.order(created_at: :desc)
    @pagy, @batches = pagy(@batches_container, items: 10)
    @batches_dependents= BatchDependent.joins(batch: :group_remit)
      .where(group_remits: {id: @group_remit.id})

    # premium and commission totals
    @batch_dependent_premiums = @batches_dependents.sum('batch_dependents.premium')
    batch_dependent_coop_commissions = @batches_dependents.sum('batch_dependents.coop_sf_amount')
    batch_dependent_agent_commissions = @batches_dependents.sum('batch_dependents.agent_sf_amount')

    @batches_premium = @batches_container.sum(:premium)
  
    @gross_premium = @batches_premium + @batch_dependent_premiums

    @total_coop_commission = @batches_container.sum(:coop_sf_amount) + batch_dependent_coop_commissions

    @total_agent_commission = @batches_container.sum(:agent_sf_amount) + batch_dependent_agent_commissions

    @net_premium = @gross_premium - @total_coop_commission

    @principal_count = @batches_container.count
    @dependent_count = @batches_dependents.count
    @single_premium = @batches[0].premium if @batches[0].present?
    @single_dependent_premium = @batches_dependents[0].premium if @batches_dependents[0].present?

  end

  def new
    @agreements = @cooperative.agreements
    @group_remit = @cooperative.group_remits.build(name: FFaker::Company.name, description: FFaker::Lorem.paragraph, agreement_id: 1, anniversary_id: 1)
    @batch = @group_remit.batches.build(effectivity_date: FFaker::Time.date, expiry_date: FFaker::Time.date, active: true, coop_sf_amount: 10, agent_sf_amount: 5, status: :recent)
  end

  def create
    @group_remit = @cooperative.group_remits.build(group_remit_params)
    @group_remit.effectivity_date = Date.today

    agreement = Agreement.find_by(id: group_remit_params[:agreement_id])
    today = Date.today

    if agreement.anniversary_type == "single" or agreement.anniversary_type == "multiple"
      anniversary_date = Anniversary.find_by(id: group_remit_params[:anniversary_id]).anniversary_date
    else
      anniversary_date = today
    end

    terms = (anniversary_date.year * 12 + anniversary_date.month) - (today.year * 12 + today.month)

    @group_remit.terms = terms <= 0 ? terms + 12 : terms
    @group_remit.expiry_date = terms <= 0 ? anniversary_date.next_year : anniversary_date

    # plan = agreement.plan
    plan = @cooperative.agreements.find_by(id: group_remit_params[:agreement_id]).plan
    agreement = @group_remit.agreement
    @group_remit.name = "#{agreement.name}(Batch-#{agreement.group_remits.count})"

    respond_to do |format|
      if @group_remit.save!
        format.html { redirect_to @group_remit, notice: "Group remit was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group_remit.update(group_remit_params)
        format.html { redirect_to @group_remit, notice: "Group remit was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
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

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
