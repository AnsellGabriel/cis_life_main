class TransmittalOr < ApplicationRecord
  belongs_to :transmittal
  belongs_to :transmittable, polymorphic: true

  def global_transmittable
    self.transmittable.to_global_id if self.transmittable.present?
  end

  def global_transmittable=(transmittable)
    self.transmittable = GlobalID::Locator.locate transmittable
  end

  def self.with_ors_already
    where(transmittable_type: ["Remittance", "LoanInsurance::GroupRemit", "BatchRemit"]).pluck(:transmittable_id)
  end
end
