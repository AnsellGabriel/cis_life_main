class Treasury::CashierEntry < ApplicationRecord
  validates_presence_of :or_no, :or_date, :global_entriable, :payment, :treasury_account_id, :amount

  enum payment: {
    gyrt: 1,
    lppi: 2
  }

  belongs_to :treasury_account, class_name: "Treasury::Account"
  belongs_to :entriable, polymorphic: true


  def to_s
    or_no
  end

  def global_entriable
    self.entriable.to_global_id if self.entriable.present?
  end

  def global_entriable=(entriable)
    self.entriable = GlobalID::Locator.locate entriable
  end
end
