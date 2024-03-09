class GroupRemit::RemarksController < ApplicationController
  before_action :set_group_remit, only: %i[index new create]

  def index
    @remarks = @group_remit.remarks.order(created_at: :desc)
  end

  def new
    @remark = @group_remit.remarks.build
  end

  def create
    @remark = @group_remit.remarks.build(remark_params.merge(user: current_user))

    if @remark.save
      redirect_to group_remit_remarks_path(@group_remit), notice: "Remark added"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def remark_params
    params.require(:remark).permit(:remark)
  end


  def set_group_remit
    @group_remit = GroupRemit.find(params[:group_remit_id])
  end
end
