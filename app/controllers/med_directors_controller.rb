class MedDirectorsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_md

  def home
    # # raise 'errors'
    # @group_remits_gyrt = GroupRemit.joins(batches: :batch_health_decs).distinct
    # @group_remits_lppi = GroupRemit.joins(batches: :batch_health_decs).distinct
    # @group_remits = @group_remits_gyrt + @group_remits_lppi
    @for_review = 0
    @reviewed = 0
    @gyrt_batches = Batch.includes(:batch_remarks).where(for_md: true)
    # @gyrt_batches = Batch.includes(:batch_remarks).where(for_md: true, insurance_status: :md_recom)
    # @lppi_batches = LoanInsurance::Batch.includes(:batch_remarks).where(for_md: true, insurance_status: :md_recom)
    @lppi_batches = LoanInsurance::Batch.includes(:batch_remarks).where(for_md: true)

    @pagy_batches, @combined = pagy_array((@batches = (@gyrt_batches + @lppi_batches).sort_by do |batch|
      if batch.batch_remarks.exists?(status: :md_reco)
        @for_review += 1
        1
      else
        @reviewed += 1
        0
      end
    end),
    items: 5, link_extra: 'data-turbo-frame="md_pagy"')
    # @for_review = for_review
    # @reviewed = reviewed
  end

  private

  def check_md
    unless current_user.userable_type == "Employee" && (current_user.userable.designation == "Medical Director" || current_user.admin?)
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

end
