class ReinsuranceMembersController < ApplicationController
  before_action :set_reinsurance_member, only: %i[ show edit update destroy ]

  # GET /reinsurance_members
  def index
    @reinsurance_members = ReinsuranceMember.all
  end

  # GET /reinsurance_members/1
  def show
  end

  # GET /reinsurance_members/new
  def new
    @reinsurance_member = ReinsuranceMember.new
  end

  # GET /reinsurance_members/1/edit
  def edit
  end

  # POST /reinsurance_members
  def create
    @reinsurance_member = ReinsuranceMember.new(reinsurance_member_params)

    if @reinsurance_member.save
      redirect_to @reinsurance_member, notice: "Reinsurance member was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reinsurance_members/1
  def update
    if @reinsurance_member.update(reinsurance_member_params)
      redirect_to @reinsurance_member, notice: "Reinsurance member was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reinsurance_members/1
  def destroy
    @reinsurance_member.destroy
    redirect_to reinsurance_members_url, notice: "Reinsurance member was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reinsurance_member
      @reinsurance_member = ReinsuranceMember.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reinsurance_member_params
      params.require(:reinsurance_member).permit(:reinsurance_id, :member_id)
    end
end
