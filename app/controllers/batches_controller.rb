class BatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cooperative, only: [:index, :new, :create, :edit, :update, :show]
  before_action :set_batch, only: [:show, :edit, :update, :destroy]

  def index
    # get all batches of the cooperative
    @batches = Batch.includes(:coop_member).where(coop_member: { cooperative_id: @cooperative.id }).all

    @pagy, @batches = pagy(@batches, items: 10)
  end

  def show
    @batch = Batch.find(params[:id])
    @batch_member = @batch.coop_member
  end

  def new
    @batch = Batch.new(effectivity_date: FFaker::Time.date, expiry_date: FFaker::Time.date, active: true, coop_sf_amount: 10, agent_sf_amount: 5, status: :recent)

    @coop_members = @cooperative.coop_members
  end

  def create
    @batch = Batch.new(batch_params)

    if @batch.save
      redirect_to @batch
    else
      render :new
    end

  end

  def edit
    @coop_members = @cooperative.coop_members
    @coop_member = @batch.coop_member
    @member = @coop_member.member
  end

  def update
    if @batch.update(batch_params)
      redirect_to @batch
    else
      render :edit
    end
  end

  def destroy
    if @batch.destroy
      redirect_to batches_path, notice: 'Batch was successfully destroyed.'
    else
      redirect_to batch_path(@batch), alert: 'Unable to destroy batch.'
    end
  end

  private
    def batch_params
      params.require(:batch).permit(:effectivity_date, :expiry_date, :active, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id)
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end

    def set_batch
      @batch = Batch.find(params[:id])
    end
end
