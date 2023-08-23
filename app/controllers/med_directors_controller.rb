class MedDirectorsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_md
  
  def home
    @group_remits = GroupRemit.joins(batches: :batch_health_decs).distinct
  end

  private

    def check_md
      unless current_user.userable_type == 'Employee' && current_user.userable.designation == 'Medical Director'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end

end
