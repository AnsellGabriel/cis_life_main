class ProgressController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    progress =  if params[:group_remit_id]
                  GroupRemit.find(params[:group_remit_id]).progress_tracker
                elsif params[:user_id]
                  User.find(params[:user_id]).progress_tracker
                end

    render json: progress
  end

  # def update
  #   progress = GroupRemit.find(params[:group_remit_id]).group_import_tracker.destroy

  #   render json: { status: :ok }
  # end
end
