class Mis::DashboardController < ApplicationController
  def index
    @encoded = GroupRemit.where(mis_entry: true)
    # @not_encoded = Treasury::CashierEntry.all
    @not_encoded = Treasury::CashierEntry.includes(:agreement).where.not(or_no: GroupRemit.pluck(:official_receipt))
    @transmitted = TransmittalOr.joins(:transmittal).where(transmittal: { transmittal_type: :mis })
    # @with_ors = GroupRemit.where.not(official_receipt: nil).where(mis_entry: true)
    @with_ors = GroupRemit.where.not(id: TransmittalOr.with_ors_already).where(mis_entry: true)

    @lppi_encoded = LoanInsurance::Batch.get_lppi_batches_count
    @gyrt_encoded = Batch.get_gyrt_encoded
  end

  def view_ors
    # raise 'error'
    @type = params[:t]
    # @encoded = GroupRemit.where(mis_entry: true)
    # @transmitted = TransmittalOr.joins(:transmittal).where(transmittal: { transmittal_type: :mis })
    # @with_ors = GroupRemit.where.not(official_receipt: nil).where(mis_entry: true)
    
    @ors = case @type
    when "enc"
      GroupRemit.where(mis_entry: true)
    when "nt"
      # GroupRemit.where.not(official_receipt: nil).where(mis_entry: true)
      GroupRemit.where.not(id: TransmittalOr.with_ors_already).where(mis_entry: true)
    when "ne"
      # Treasury::CashierEntry.all
      Treasury::CashierEntry.includes(:agreement).where.not(or_no: GroupRemit.pluck(:official_receipt))
    end

    if params[:search].present?
      if @type == "ne"
        @filtered_ors = @ors.where(or_no: params[:search]) 
      else
        @filtered_ors = @ors.where(official_receipt: params[:search]) 
      end
    else
      @filtered_ors = @ors
    end
    
    @pagy_ors, @filtered_ors = pagy(@filtered_ors, items: 25)
  end
end
