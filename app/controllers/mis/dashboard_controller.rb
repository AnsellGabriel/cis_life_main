class Mis::DashboardController < ApplicationController
  def index
    @encoded = GroupRemit.where(mis_entry: true)
    @transmitted = TransmittalOr.joins(:transmittal).where(transmittal: { transmittal_type: :mis })
    @with_ors = GroupRemit.where.not(official_receipt: nil).where(mis_entry: true)

    @lppi_encoded = LoanInsurance::Batch.get_lppi_batches_count
    @gyrt_encoded = Batch.get_gyrt_encoded
  end

  def view_ors
    @type = params[:t]
    @encoded = GroupRemit.where(mis_entry: true)
    @transmitted = TransmittalOr.joins(:transmittal).where(transmittal: { transmittal_type: :mis })
    @with_ors = GroupRemit.where.not(official_receipt: nil).where(mis_entry: true)
  end

end
