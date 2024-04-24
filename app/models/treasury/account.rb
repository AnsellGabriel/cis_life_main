class Treasury::Account < ApplicationRecord
  validates_presence_of :name, :code, :account_type, :account_category
  validates :name, :code, uniqueness: true
  validates :account_number, presence: true, length: { maximum: 18 }, format: { with: /\A\d+\z/ }, if: :bank?


  before_save :set_code, if: :new_record?
  before_save :check_account_number

  enum account_type: {
    assets: 1,
    liabilities: 2,
    equity: 3,
    income: 4,
    expense: 5,
    statutory_reserve: 6
  }

  enum account_category: {
    main: 0,
    sub_account: 1,
    bank: 2
  }

  has_many :check_vouchers, class_name: "Accounting::CheckVoucher"
  has_many :cashier_entries, class_name: "Treasury::CashierEntry"
  has_many :general_ledgers
  has_many :coop_banks
  has_many :cooperatives, through: :coop_banks

  def to_s
    name
  end

  def self.trial_balance_pdf(employee_id, date_from, date_to)
    Reports::TrialBalancePdfJob.perform_async(employee_id, date_from, date_to)
  end

  def total_debit
    self.general_ledgers.debits.sum(:amount)
  end

  private

  def total_credit
    self.general_ledgers.credits.sum(:amount)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "code"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def set_code
    code_initials = case self.account_type
                      when 1 then 'A'
                      when 2 then 'L'
                      when 3 then 'M'
                      when 4 then 'I'
                      when 5 then 'E'
                      when 6 then 'S'
                    end

    last_account = Treasury::Account.where(account_type: self.account_type).last
    last_code = last_account.nil? ? 0001 : last_account.code.slice(2..-1).to_i + 1
    self.code = "#{code_initials}-#{sprintf("%04d", last_code)}"
  end

  def check_account_number
    if self.bank?
      if self.account_number.nil?
        errors.add(:account_number, "can't be blank")
      end
    end
  end

  def account_number_contains_only_digits
    unless account_number.to_s.numeric?
      errors.add(:account_number, "must contain only digits")
    end
  end
end
