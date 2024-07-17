class Treasury::CashierEntry < ApplicationRecord
  attr_accessor :dummy_payee, :dummy_entry_type, :product_check, :vat_check, :discount_check
  before_save :add_deposit, :check_fields#, :format_or_no

  validates_presence_of :or_no, :or_date, :treasury_account_id, :amount, :employee_id, :branch, :global_entriable

  enum status: { pending: 0, posted: 1, cancelled: 2, for_approval: 3}
  # enum branch: { head_office: 0, cagayan_de_oro: 1, iloilo: 2, davao: 3, }

  belongs_to :treasury_account, class_name: "Treasury::Account"
  belongs_to :treasury_payment_type, class_name: "Treasury::PaymentType"
  belongs_to :branch
  belongs_to :employee
  belongs_to :agent, optional: true
  belongs_to :entriable, polymorphic: true
  belongs_to :agreement, optional: true
  belongs_to :plan, optional: true

  has_many :bills, class_name: "Treasury::BillingStatement", dependent: :destroy
  has_many :general_ledgers, as: :ledgerable, dependent: :destroy
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

  def show_agent
    self.agent or entriable.payable.agreement.agent
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

  def check_if_mis_encoded
    agreement&.group_remits&.find_by(group_remits: { official_receipt: self.or_no})
  end

  def self.check_ors_agreement(agreement)
    where(entriable: agreement.cooperative, plan: agreement.plan, agreement: nil).count
  end

  def self.get_ors(agreement)
    where(entriable: agreement.cooperative, plan: agreement.plan, agreement: nil)
  end

  def check_agreement
    if plan.present?
      moa = Agreement.find_by(cooperative: entriable, plan: plan)

      if moa.present?
        self.agreement = moa
      end
    end
  end

  def add_deposit
    self.deposit = self.amount if self.deposit.nil?
  end

  private

  def format_or_no
    self.or_no = sprintf("%06d", self.or_no.to_i) # "00001"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["or_no"]
  end

  def check_fields
    unless self.insurance?
      self.agent = nil
      self.plan = nil
      self.deposit = 0
      self.service_fee = 0
      self.unuse = 0
    end

    unless self.discounted?
      self.discount = 0
      self.withholding_tax = 0
    end

    unless self.vatable?
      self.vat_exempt = 0
      self.zero_rated = 0
      self.vatable_amount = 0
      self.vat = 0
    end
  end
end
