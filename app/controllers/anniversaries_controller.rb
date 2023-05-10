class AnniversariesController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type

  private

    def anniversary_params
      params.require(:anniversary).permit(:name, :anniversary_date)
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        redirect_to :authenticated_root, alert: "You don't have access to this page"
      end
    end
end
