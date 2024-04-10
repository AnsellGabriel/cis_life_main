class Treasury::CashierEntry < ApplicationRecord
  attr_accessor :dummy_payee, :dummy_entry_type
  before_save :format_or_no

  validates_presence_of :or_no, :or_date, :treasury_account_id, :global_entriable, :amount

  # enum payment_type: { gyrt: 1, lppi: 2, others: 3 }
  enum status: { pending: 0, posted: 1, cancelled: 2, for_approval: 3}

  belongs_to :treasury_account, class_name: "Treasury::Account"
  belongs_to :treasury_payment_type, class_name: "Treasury::PaymentType"
  belongs_to :entriable, polymorphic: true

  has_many :payments, class_name: "Treasury::Payment", dependent: :destroy
  has_many :bills, class_name: "Treasury::BillingStatement", dependent: :destroy
  has_many :general_ledgers, as: :ledgerable

  def to_s
    self.or_no
  end

  def reference
    self.or_no
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

  # def autofill(payment)
  #   general_ledgers.destroy_all

  #   general_ledgers.create(
  #     account: treasury_account,
  #     description: "Cash in - #{treasury_account}",
  #     ledger_type: 0,
  #     amount: amount
  #   )

  #   general_ledgers.create(
  #     account: service_fee(payment_type),
  #     description: service_fee(payment_type).name,
  #     ledger_type: 0,
  #     amount: payment.payable.coop_commission
  #   )

  #   general_ledgers.create(
  #     account: premium_income(payment_type),
  #     description: premium_income(payment_type).name,
  #     ledger_type: 1,
  #     amount: total_amount
  #   )
  # end

  private
  def format_or_no
    self.or_no = sprintf("%06d", self.or_no) # "00001"
  end

  # def service_fee(payment_type)
  #   case payment_type
  #   when 'gyrt'
  #     Treasury::Account.find_by(name: 'Service Fee - GYRT')
  #   when 'lppi'
  #     Treasury::Account.find_by(name: 'Service Fee - LPPI')
  #   end
  # end

  # def premium_income(payment_type)
  #   case payment_type
  #   when 'gyrt'
  #     Treasury::Account.find_by(name: 'Premium Income - GYRT')
  #   when 'lppi'
  #     Treasury::Account.find_by(name: 'Premium Income - LPPI')
  #   end
  # end

  def self.ransackable_attributes(auth_object = nil)
    ["or_no"]
  end
end
