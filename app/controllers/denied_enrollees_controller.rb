class DeniedEnrolleesController < ApplicationController
  before_action :authenticate_user!

  def index
    @denied_enrollees = @cooperative.denied_enrollees.order(created_at: :desc)
  end

  def destroy
    @denied_enrollee = DeniedEnrollee.find(params[:id])
    @denied_enrollee.destroy!
    redirect_to denied_enrollees_path, notice: "Denied enrollee deleted successfully."
  end
end
