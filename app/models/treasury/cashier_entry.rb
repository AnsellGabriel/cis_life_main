class Treasury::CashierEntry < ApplicationRecord
  attr_accessor :dummy_payee

  validates_presence_of :or_no, :or_date, :payment, :treasury_account_id, :amount

  enum payment: {
    gyrt: 1,
    lppi: 2
  }

  belongs_to :treasury_account, class_name: "Treasury::Account"
  belongs_to :entriable, polymorphic: true

  has_many :payments, class_name: "Treasury::Payment", dependent: :destroy
  has_many :billing_statements, class_name: "Treasury::BillingStatement", dependent: :destroy

  def to_s
    or_no
  end

  def global_entriable
    self.entriable.to_global_id if self.entriable.present?
  end

  def global_entriable=(entriable)
    self.entriable = GlobalID::Locator.locate entriable
  end

  def coop
    entriable.payable.agreement.cooperative
  end

  def agent
    entriable.payable.agreement
  end
end
