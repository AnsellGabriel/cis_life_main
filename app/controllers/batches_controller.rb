class BatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cooperative, only: %i[index new create edit update show]
  before_action :set_batch, only: %i[show edit update destroy]
  before_action :set_group_remit, only: %i[index new create edit update show]

  def index
    # get all batches of the cooperative
    @batches = @group_remit.batches

    @pagy, @batches = pagy(@batches, items: 10)
  end

  def show
    @batch_member = @batch.coop_member
    @effectivity_date = @batch.group_remit.effectivity_date
    @expiry_date = @batch.group_remit.expiry_date
  end

  def new
    @coop_members = @cooperative.coop_members.includes(:member).order('members.last_name')

    @batch = @group_remit.batches.new(effectivity_date: FFaker::Time.date, expiry_date: FFaker::Time.date, active: true, status: :recent)


    # @member_dependent = @member.member_dependents.build
    # @batch_dependent = @batch.batch_dependents.build
  end

  def create
    @coop_members = @cooperative.coop_members.includes(:member).order('members.last_name')
    @batch = @group_remit.batches.new(batch_params)

    premium = @group_remit.agreement.premium
    coop_sf = @group_remit.agreement.coop_service_fee
    agent_sf = @group_remit.agreement.agent_service_fee

    @batch.coop_sf_amount = (coop_sf/100) * premium 
    @batch.agent_sf_amount = (agent_sf/100) * premium 
    @batch.premium = premium 

    respond_to do |format|
      if @batch.save!
        # format.turbo_stream
        format.html { 
          redirect_to group_remit_path(@group_remit), notice: "Batch created"
        }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end

  end

  def edit
  @coop_members = @cooperative.coop_members.includes(:member).order('members.last_name')

  end

  def update

    respond_to do |format|
      if @batch.update(batch_params)
        format.html { 
          redirect_to group_remit_path(@group_remit), notice: "Batch updated"
        }
        # format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    
    respond_to do |format|
      if @batch.destroy
        format.html {
          redirect_to group_remit_path(@group_remit), notice: 'Batch was successfully destroyed.'
        }
        format.turbo_stream
      else
        format.html {
          redirect_to group_remit_batch_path(@group_remit, @batch), alert: 'Unable to destroy batch.'
        }
      end
    end  
  end

  private
    def batch_params
      params.require(:batch).permit(:active, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id, batch_dependents_attributes: [:member_dependent_id, :beneficiary, :_destroy])
    end

    def set_group_remit
      @cooperative = current_user.userable.cooperative
      @group_remit = @cooperative.group_remits.find_by(id: params[:group_remit_id])
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end

    def set_batch
      @group_remit = @cooperative.group_remits.find_by(id: params[:group_remit_id])
      @batch = @group_remit.batches.find_by(id: params[:id])
    end

    # def set_coop_members_name(members)
      
    # end
end
