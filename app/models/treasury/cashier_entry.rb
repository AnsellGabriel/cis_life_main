class Treasury::CashierEntry < ApplicationRecord
  attr_accessor :dummy_payee, :dummy_entry_type

  validates_presence_of :or_no, :or_date, :payment_type, :treasury_account_id

  enum payment_type: { gyrt: 1, lppi: 2, others: 3 }
  enum status: { pending: 0, posted: 1, cancelled: 2 }

  belongs_to :treasury_account, class_name: "Treasury::Account"
  belongs_to :entriable, polymorphic: true

  has_many :payments, class_name: "Treasury::Payment", dependent: :destroy
  has_many :bills, class_name: "Treasury::BillingStatement", dependent: :destroy
  has_many :general_ledgers, as: :ledgerable

  def to_s
    or_no
  end

  def entry_type
    'ce'
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
    if remittance?
      entriable.payable.agreement.cooperative
    else
      entriable
    end
  end

  def agent
    entriable.payable.agreement.agent
  end

  def total_amount
    if remittance?
      entriable.payable.gross_premium
    else
      amount
    end
  end

  # def net_amount
  #   if remittance?
  #     entriable.payable.gross_premium
  #   else
  #     amount
  #   end
  # end

  def remittance?
    self.entriable_type == 'Payment'
  end

end
