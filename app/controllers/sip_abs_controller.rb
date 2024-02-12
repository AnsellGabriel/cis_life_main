class SipAbsController < ApplicationController
  before_action :set_sip_ab, only: %i[ show edit update destroy ]

  # GET /sip_abs
  def index
    @sip_abs = SipAb.all
  end

  # GET /sip_abs/1
  def show
  end

  # GET /sip_abs/new
  def new
    @sip_ab = SipAb.new
  end

  # GET /sip_abs/1/edit
  def edit
  end

  # POST /sip_abs
  def create
    @sip_ab = SipAb.new(sip_ab_params)

    if @sip_ab.save
      redirect_to @sip_ab, notice: "Sip ab was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sip_abs/1
  def update
    if @sip_ab.update(sip_ab_params)
      redirect_to @sip_ab, notice: "Sip ab was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /sip_abs/1
  def destroy
    @sip_ab.destroy
    redirect_to sip_abs_url, notice: "Sip ab was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sip_ab
      @sip_ab = SipAb.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sip_ab_params
      params.require(:sip_ab).permit(:name, :min_age, :max_age, :insured_type, :exit_age)
    end
end
