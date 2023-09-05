class MedDirectorsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_md
  
  def home
    # # raise 'errors'
    @group_remits_gyrt = GroupRemit.joins(batches: :batch_health_decs).distinct
    @group_remits_lppi = GroupRemit.joins(loan_batches: :batch_health_decs).distinct
    @group_remits = @group_remits_gyrt + @group_remits_lppi

  end

  private

    def check_md
      unless current_user.userable_type == 'Employee' && current_user.userable.designation == 'Medical Director'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end

end
