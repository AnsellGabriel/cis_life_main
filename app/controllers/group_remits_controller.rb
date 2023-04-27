class GroupRemitsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_group_remit, only: %i[show edit update destroy]
  before_action :set_cooperative, only: %i[new edit update show]
  before_action :set_members, only: %i[new create edit update]

  def index
    @group_remits = GroupRemit.all
    # @batches = @group_remit.batches
  end

  def show
    @batches = @group_remit.batches.order(created_at: :desc)

    # byebug
    # filter members based on last name, first name, middle name
    # @members = f_members.where("last_name LIKE ? AND first_name LIKE ? AND middle_name LIKE ?", "%#{params[:last_name_filter]}%", "%#{params[:first_name_filter]}%", "%#{params[:middle_name_filter]}%")

    @pagy, @batches = pagy(@batches, items: 10)
    @total_premium = @group_remit.batches.sum(:premium)
    @total_coop_commission = @group_remit.batches.sum(:coop_sf_amount)
    @total_agent_commission = @group_remit.batches.sum(:agent_sf_amount)

  end

  def new
    @group_remit = GroupRemit.new(name: FFaker::Company.name, description: FFaker::Lorem.paragraph, agreement_id: 1, anniversary_id: 1)
    @batch = @group_remit.batches.build(effectivity_date: FFaker::Time.date, expiry_date: FFaker::Time.date, active: true, coop_sf_amount: 10, agent_sf_amount: 5, status: :recent)
  end

  def create
    @group_remit = GroupRemit.new(group_remit_params)

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
    @coop_members = @cooperative.coop_members
    @members = Member.joins(:coop_members).where(coop_members: { id: @coop_members.ids }).order(:last_name)

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
      @group_remit = GroupRemit.find(params[:id])
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
