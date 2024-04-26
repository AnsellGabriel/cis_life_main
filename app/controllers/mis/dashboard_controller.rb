class Mis::DashboardController < ApplicationController
  def index
    @encoded = GroupRemit.where(mis_entry: true)
    @transmitted = TransmittalOr.joins(:transmittal).where(transmittal: { transmittal_type: :mis })
  end

end
