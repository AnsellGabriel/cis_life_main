class MedDirectorsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_md

  def home
    # # raise 'errors'
    # @group_remits_gyrt = GroupRemit.joins(batches: :batch_health_decs).distinct
    # @group_remits_lppi = GroupRemit.joins(batches: :batch_health_decs).distinct
    # @group_remits = @group_remits_gyrt + @group_remits_lppi

    @gyrt_batches = Batch.where(for_md: true)
    @lppi_batches = LoanInsurance::Batch.where(for_md: true)

    @batches = @gyrt_batches + @lppi_batches

  end

  private

    def check_md
      unless current_user.userable_type == 'Employee' && (current_user.userable.designation == 'Medical Director' || current_user.admin?)
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end

end
