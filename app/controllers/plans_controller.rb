class PlansController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_cooperative, only: %i[index new create show]

  private

    def plan_params
      params.require(:plan).permit(:name, :description, :acronym)
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
