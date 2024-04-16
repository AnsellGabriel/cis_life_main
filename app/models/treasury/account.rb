class Treasury::Account < ApplicationRecord
  enum account_type: {
    assets: 1,
    liabilities: 2,
    equity: 3,
    income: 4,
    expense: 5,
    statutory_reserve: 6
  }

  has_many :check_vouchers, class_name: "Accounting::CheckVoucher"
  has_many :cashier_entries, class_name: "Treasury::CashierEntry"
  has_many :general_ledgers

  def to_s
    name
  end

  def self.trial_balance_pdf(employee_id, date_from, date_to)
    Reports::TrialBalancePdfJob.perform_async(employee_id, date_from, date_to)
  end

  def total_debit
    self.general_ledgers.debits.sum(:amount)
  end

  def total_credit
    self.general_ledgers.credits.sum(:amount)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "code"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
