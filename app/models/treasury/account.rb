class Treasury::Account < ApplicationRecord
  validates_presence_of :name, :code, :account_type
  # validates :code, uniqueness: true
  validates :account_number, presence: true, length: { maximum: 18 }, format: { with: /\A\d+\z/ }, if: :bank?

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
  has_many :beginning_balances, class_name: "Accounting::AccountBeginningBalance"

  scope :child_accounts, -> { where.not(code: ['A-1', 'L-1', 'S-1', 'E-1', 'I-1', 'M-1', 'A-1-2', 'A-1-1']).order(:name) }


  def to_s
    name
  end

  def self.trial_balance_pdf(employee_id, date_from, date_to)
    Reports::TrialBalancePdfJob.perform_async(employee_id, date_from, date_to)
  end

  def total_debit
    self.general_ledgers.debits.sum(:amount)
  end

  def add_bank(name, address)
    self.name = name
    self.address = address
    self.account_type = :assets
    self.account_category = :bank
    self.set_code
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
                      when "assets" then 'A'
                      when "liabilities" then 'L'
                      when "equity" then 'M'
                      when "income" then 'I'
                      when "expense" then 'E'
                      when "statutory_reserve" then 'S'
                    end

    last_account = Treasury::Account.where(account_type: self.account_type).last
    last_code = last_account.nil? ? 0001 : last_account.code.slice(2..-1).to_i + 1
    self.code = "#{code_initials}-#{sprintf("%04d", last_code)}"
  end
end
