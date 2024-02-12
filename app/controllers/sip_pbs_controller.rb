class SipPbsController < ApplicationController
  before_action :set_sip_pb, only: %i[ show edit update destroy ]

  # GET /sip_pbs
  def index
    @sip_pbs = SipPb.all
  end

  # GET /sip_pbs/1
  def show
  end

  # GET /sip_pbs/new
  def new
    @sip_pb = SipPb.new
  end

  # GET /sip_pbs/1/edit
  def edit
  end

  # POST /sip_pbs
  def create
    @sip_pb = SipPb.new(sip_pb_params)

    if @sip_pb.save
      redirect_to @sip_pb, notice: "Sip pb was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sip_pbs/1
  def update
    if @sip_pb.update(sip_pb_params)
      redirect_to @sip_pb, notice: "Sip pb was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /sip_pbs/1
  def destroy
    @sip_pb.destroy
    redirect_to sip_pbs_url, notice: "Sip pb was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sip_pb
      @sip_pb = SipPb.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sip_pb_params
      params.require(:sip_pb).permit(:sip_ab_id, :benefit_id, :coverage_amount, :premium, :description, :plan_unit_id)
    end
end
