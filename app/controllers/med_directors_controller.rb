class MedDirectorsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_md

  def home
    @for_review = 0
    @reviewed = 0
    @gyrt_batches = Batch.includes(:batch_remarks).where(for_md: true)
    @lppi_batches = LoanInsurance::Batch.includes(:batch_remarks).where(for_md: true)

    @pagy_batches, @combined = pagy_array((@batches = (@gyrt_batches + @lppi_batches).sort_by do |batch|
      @md = User.find_by(rank: :medical_director)
      # if batch.batch_remarks.where(status: :md_reco).count > 0 || batch.insurance_status == "approved"
      if batch.batch_remarks.where(user: @md.userable).count > 0 || batch.insurance_status == "approved"
        @reviewed += 1
        0
      else
        @for_review += 1
        1
      end
    end),
    items: 5, link_extra: 'data-turbo-frame="md_pagy"')
end

  private

  def check_md
    unless current_user.userable_type == "Employee" && (current_user.userable.designation == "Medical Director" || current_user.admin?)
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

end
