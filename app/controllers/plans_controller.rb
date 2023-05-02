class PlansController < InheritedResources::Base
  before_action :set_cooperative, only: %i[index new create show]

  private

    def plan_params
      params.require(:plan).permit(:name, :description, :acronym)
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end
end
