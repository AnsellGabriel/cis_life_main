class ClaimRemarksController < ApplicationController
  before_action :set_claim_remark, only: %i[ show edit update destroy ]


  def index
    if current_user.userable == "CoopUser"
      @cooperative = current_user.userable.cooperative
      @claim_remarks = ClaimRemark.joins(:process_claim).where(read: 0, process_claim: { cooperative_id: @cooperative.id }).where.not(user: current_user)
    else
      @claim_remarks = ClaimRemark.joins(:process_claim).where(read: 0).where.not(user: current_user)
    end

    @process_claims = ProcessClaim.where(cooperative: @cooperative)
  end

  def new_status
    @process_claim = ProcessClaim.find(params[:v])
    @claim_remark = @process_claim.claim_remarks.build
    @status = params[:s]

    if @status == "1"
      @claim_remark.status = :denied
    elsif @status == "2"
      @claim_remark.status = :pending
    elsif @status == "3"
      @claim_remark.status = :reconsider
    end
    @claim_remark.remark = FFaker::HealthcareIpsum.paragraph
    # @claim_remark.status =
    # raise "error"
  end
  def new
    @process_claim = ProcessClaim.find(params[:v])
    @claim_remark = @process_claim.claim_remarks.build
    @claim_remarks = ClaimRemark.where(process_claim: @process_claim, coop: 1)
    # raise "error"
    # @claim_remark.coop = params[:c]
    set_dummy_param
  end

  def set_dummy_param
    if params[:c] == "1"
      @claim_remark.coop = :true
      @process_claim.claim_remarks.where(coop: 1, read: 0).where.not(user: current_user).update(read: 1)
    elsif params[:c] == "0"
      @claim_remark.coop = :false
    end
    @claim_remark.user = current_user
    # @claim_remark.status = params[:s]
    @claim_remark.remark = FFaker::HealthcareIpsum.paragraph
  end

  def edit
  end

  def create_status
    @process_claim = ProcessClaim.find(params[:v])
    @claim_remark = @process_claim.claim_remarks.build(claim_remark_params)
    @claim_remark.user = current_user
    @claim_remark.coop = 0
    @claim_remark.read = 0
    @claim_remark.pin = 0
    # raise "error"
    respond_to do |format|
      if @claim_remark.save
        if @claim_remark.denied?
          pt = ProcessTrack.create(route_id: 9, user: current_user, trackable: @process_claim)
          @process_claim.update(status: :denied)
        elsif @claim_remark.pending?
          pt = ProcessTrack.create!(route_id: 11, user: current_user, trackable: @process_claim)
          @process_claim.update(status: :pending, claim_route: pt.route_id)
        elsif @claim_remark.reconsider?
          pt = ProcessTrack.create!(route_id: 10, user: current_user, trackable: @process_claim)
          @process_claim.update(status: :reconsider, claim_route: pt.route_id)
        end
        format.html { redirect_back fallback_location: claim_process_process_claim_path(@process_claim), notice: "Claim remark was successfully created." }
        format.json { render :show, status: :created, location: @claim_remark }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @claim_remark.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def create
    @process_claim = ProcessClaim.find(params[:v])
    @claim_remark = @process_claim.claim_remarks.build(claim_remark_params)
    @claim_remark.user = current_user
    @claim_remark.read = 0
    @claim_remark.pin = 0
    # raise "error"
    respond_to do |format|
      if @claim_remark.save
        format.html { redirect_back fallback_location: claim_process_process_claim_path(@process_claim), notice: "Claim remark was successfully created." }
        format.json { render :show, status: :created, location: @claim_remark }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @claim_remark.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @claim_remark.update(claim_remark_params)
        format.html { redirect_back fallback_location: @process_claim, notice: "Claim remark was successfully updated." }
        format.json { render :show, status: :ok, location: @claim_remark }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @claim_remark.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def read_message
    @claim_remark
    respond_to do |format|
      if @registration.update_attribute(:attend, @attend)
        # format.html { redirect_back fallback_location: registrations_path, notice: "Updated" }
        redirect_back(fallback_location: root_path)
      end
    end
  end

  def destroy
    @claim_remark.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: @process_claim, notice: "Claim remark was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_claim_remark
    @claim_remark = ClaimRemark.find(params[:id])
    @process_claim = @claim_remark.process_claim
  end

  # Only allow a list of trusted parameters through.
  def claim_remark_params
    params.require(:claim_remark).permit(:process_claim_id, :user_id, :status, :remark, :coop, :read)
  end
end
