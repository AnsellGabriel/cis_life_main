class Treasury::CashierEntry < ApplicationRecord
  attr_accessor :dummy_payee, :dummy_entry_type
  before_save :format_or_no

  validates_presence_of :or_no, :or_date, :treasury_account_id, :global_entriable, :amount

  # enum payment_type: { gyrt: 1, lppi: 2, others: 3 }
  enum status: { pending: 0, posted: 1, cancelled: 2, for_approval: 3}
  enum branch: { head_office: 0, cagayan_de_oro: 1, iloilo: 2, davao: 3}

  belongs_to :treasury_account, class_name: "Treasury::Account"
  belongs_to :treasury_payment_type, class_name: "Treasury::PaymentType"
  belongs_to :entriable, polymorphic: true
  #magic for entriable
  # belongs_to :payment, ->{includes(:treasury_cashier_entries).where(treasury_cashier_entries: {entriable_type: "Payment"})}, foreign_key: "entriable_id"
  # has_many :payments, class_name: "Treasury::Payment", dependent: :destroy
  # has_many :payments, dependent: :destroy
  has_many :bills, class_name: "Treasury::BillingStatement", dependent: :destroy
  has_many :general_ledgers, as: :ledgerable
  has_many :transmittable_ors, as: :transmittable, inverse_of: :transmittable 
  has_many :transmittals, through: :transmittable_ors


  ORS = Treasury::CashierEntry.all.to_a

  def to_s
    self.or_no
  end

  def for_transmittal
    "#{self.or_no} - #{entriable}"
  end
  
  def self.receipt_book_pdf(employee_id, date_from, date_to, type)
    Reports::BooksPdfJob.perform_async(employee_id, date_from, date_to, type)
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

  def remittance?
    self.entriable_type == 'Payment'
  end

  private

  def format_or_no
    self.or_no = sprintf("%06d", self.or_no.to_i) # "00001"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["or_no"]
  end
end
