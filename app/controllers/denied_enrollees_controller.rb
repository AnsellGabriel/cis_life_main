class DeniedEnrolleesController < ApplicationController
  before_action :authenticate_user!

  def index
    @denied_enrollees = @cooperative.denied_enrollees.order(created_at: :desc)
  end

  def destroy
    # @cooperative.denied_enrollees.destroy_all

    # redirect_to coop_members_path, notice: "Denied enrollees deleted successfully."
  end

  def destroy_all
    @cooperative.denied_enrollees.destroy_all

    if current_user.userable_type == "CoopUser"
      redirect_to coop_members_path, notice: "Denied enrollees deleted successfully."
    else
      redirect_to cooperative_path(@cooperative), notice: "Denied enrollees deleted successfully."
    end
  end
end
