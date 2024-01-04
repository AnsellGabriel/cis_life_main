class PlansController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type
  # before_action :set_cooperative, only: %i[index new create show]
  # before_action :check_userable_type
  # before_action :set_cooperative, only: %i[index new create show]

  def selected
    @target = params[:target]
    @units = PlanUnit.where(plan_id: params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :description, :acronym, :dependable, :entry_age_from, :entry_age_to, :exit_age, :min_participation)
  end

  def set_cooperative
    # @cooperative = current_user.userable.cooperative
  end

  def check_userable_type
    unless current_user.userable_type == "CoopUser" || current_user.userable_type == "Employee"
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end
end
