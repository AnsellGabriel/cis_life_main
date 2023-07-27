class ProgressController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    progress_data = {
      progress: session[:member_import_progress]["progress"]
    }
  
    render json: progress_data
  end

  def update
    session[:member_import_progress] = {
      progress: 0
    }

    render json: { status: :ok }
  end
end
