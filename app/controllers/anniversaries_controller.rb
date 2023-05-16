class AnniversariesController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type

  private

    def anniversary_params
      params.require(:anniversary).permit(:name, :anniversary_date, :agreement_id)
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
