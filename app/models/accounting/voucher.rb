class Accounting::Voucher < ApplicationRecord
  validates_presence_of :date_voucher, :global_payable, :particulars, :voucher

  belongs_to :payable, polymorphic: true

  enum audit: { for_audit: 0, approved: 1, pending: 2 }

  def to_s
    voucher
  end

  def global_payable
    self.payable.to_global_id if self.payable.present?
  end

  def global_payable=(payable)
    self.payable = GlobalID::Locator.locate payable
  end
end
