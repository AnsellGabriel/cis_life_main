class Treasury::CashierEntry < ApplicationRecord
  attr_accessor :dummy_payee, :dummy_entry_type

  validates_presence_of :or_no, :or_date, :payment_type, :treasury_account_id

  enum payment_type: { gyrt: 1, lppi: 2 }
  enum status: { pending: 0, posted: 1, cancelled: 2 }

  belongs_to :treasury_account, class_name: "Treasury::Account"
  belongs_to :entriable, polymorphic: true

  has_many :payments, class_name: "Treasury::Payment", dependent: :destroy
  has_many :bills, class_name: "Treasury::BillingStatement", dependent: :destroy
  has_many :general_ledgers, as: :ledgerable
  # accepts_nested_attributes_for :general_ledgers,
  #                               allow_destroy: true

  def to_s
    or_no
  end

  def self.payment_enum_value(key)
    key = key.to_sym
    payment_types[key] if payment_types.key?(key)
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
    entriable.payable.agreement.agent
  end

end
