class BatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cooperative, only: [:new, :create, :edit, :update, :show]
  before_action :set_batch, only: [:show, :edit, :update, :destroy]

  def index
    @batches = Batch.all
    @pagy, @batches = pagy(@batches, items: 10)
  end

  def show
    @batch = Batch.find(params[:id])
    @batch_members = @batch.coop_members.map {|coop| coop.member}
    @sorted_members = @batch_members.sort_by(&:last_name)
  end

  def new
    @batch = Batch.new(effectivity_date: FFaker::Time.date, expiry_date: FFaker::Time.date, active: true, coop_sf_amount: 10, agent_sf_amount: 5, status: 0)

    @coop_members = @cooperative.coop_members
  end

  def create
    @batch = Batch.new(batch_params)

    if @batch.save
      @batch.coop_members = CoopMember.where(id: params[:batch][:coop_member_ids])
      redirect_to @batch
    else
      render :new
    end

  end

  def edit
    @coop_members = @batch.coop_members
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
      params.require(:batch).permit(:effectivity_date, :expiry_date, :active, :coop_sf_amount, :agent_sf_amount, :status, :premium,coop_member_ids: [])
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end

    def set_batch
      @batch = Batch.find(params[:id])
    end
end
