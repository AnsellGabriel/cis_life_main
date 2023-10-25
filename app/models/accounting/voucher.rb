class Accounting::Voucher < ApplicationRecord
  validates_presence_of :date_voucher, :voucher, :payable_type, :payable_id, :particulars

  belongs_to :payable, polymorphic: true

  def global_payable
    self.payable.to_global_id if self.payable.present?
  end

  def global_payable=(payable)
    self.payable = GlobalID::Locator.locate payable
  end
end
