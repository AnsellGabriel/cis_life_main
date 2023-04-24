class GroupRemitsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_group_remit, only: [:show, :edit, :update, :destroy]
  before_action :set_cooperative, only: [:new]

  def index
    @group_remits = GroupRemit.all
    # @batches = @group_remit.batches
  end

  def show
    @batches = @group_remit.batches
    @pagy, @batches = pagy(@batches, items: 10)
  end

  def new
    @group_remit = GroupRemit.new
    @batch = @group_remit.batches.build
    @coop_members = @cooperative.coop_members
    @members = Member.joins(:coop_members).where(coop_members: { id: @coop_members.ids }).order(:last_name)
  end


  private

    def set_group_remit
      @group_remit = GroupRemit.find(params[:id])
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end

    def group_remit_params
      params.require(:group_remit).permit(:name, :description, :agreement_id, :anniversary_id, batches_attributes: [:effectivity_date, :expiry_date, :active, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id, :_destroy, batch_dependents_attributes: [:member_dependent_id, :beneficiary, :_destroy]])
    end

end
