class Claims::RemarksController < ApplicationController
  before_action :set_process_claim

  def index
    @notes = @process_claim.remarks.order(created_at: :desc)
  end

  def new
    @note = @process_claim.remarks.build
  end

  def create
    @note = @process_claim.remarks.build(remark_params.merge(user: current_user))

    if @note.save
      redirect_to claims_process_claim_remarks_path(@process_claim), notice: "Note added successfully."
    else
      render :new
    end
  end

  private

  def remark_params
    params.require(:remark).permit(:remark)
  end

  def set_process_claim
    @process_claim = Claims::ProcessClaim.find(params[:process_claim_id])
  end
end
