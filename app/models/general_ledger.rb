class GeneralLedger < ApplicationRecord
  validates_presence_of :ledger_type, :account_id, :amount, :description, :ledgerable_id, :ledgerable_type

  belongs_to :ledgerable, polymorphic: true
  belongs_to :account, class_name: "Treasury::Account", foreign_key: "account_id"

  enum ledger_type: { debit: 0, credit: 1 }

  scope :debits , -> { where(ledger_type: 0) }
  scope :credits, -> { where(ledger_type: 1) }
  scope :with_transaction_date, ->(date_from, date_to) { where(transaction_date: date_from..date_to) }

  def self.total_debit
    debits.sum(:amount)
  end

  def self.total_credit
    credits.sum(:amount)
  end

  def self.to_csv(employee_id, account_id, date_from, date_to)
    Reports::AccountLedgerCsvJob.perform_async(employee_id, account_id, date_from, date_to)
  end

  def self.to_pdf(employee_id, account_id, date_from, date_to)
    Reports::AccountLedgerPdfJob.perform_async(employee_id, account_id, date_from, date_to)
  end

  def self.autofill(ledgerable_type, ledgerable)
    ledger_entries = ledgerable.general_ledgers
    ledger_entries.destroy_all

    case ledgerable_type
    when "ce"
      cashier_entry = ledgerable
      payment_type = cashier_entry.payment_type

      ledger_entries.create(
        account: cashier_entry.treasury_account,
        description: "Cash in - #{cashier_entry.treasury_account.name}",
        ledger_type: 0,
        amount: cashier_entry.amount
      )

      ledger_entries.create(
        account: service_fee_account(payment_type),
        description: service_fee_account(payment_type).name,
        ledger_type: 0,
        amount: cashier_entry.entriable.payable.coop_commission
      )

      ledger_entries.create(
        account: premium_income_account(payment_type),
        description: premium_income_account(payment_type).name,
        ledger_type: 1,
        amount: cashier_entry.total_amount
      )
    when "cv"
      check_voucher = ledgerable
      claims_acount = Treasury::Account.find_by(name: 'Claims')

      ledger_entries.create(
        account: claims_acount,
        description: claims_acount.name,
        ledger_type: 0,
        amount: check_voucher.amount
      )

      ledger_entries.create(
        account: check_voucher.treasury_account,
        description: "Cash in - #{check_voucher.treasury_account.name}",
        ledger_type: 1,
        amount: check_voucher.amount
      )
    end
  end

  def payee
    case ledgerable_type
    when "Treasury::CashierEntry"
      if self.ledgerable.entriable_type == "Payment"
        self.ledgerable.entriable.payable.agreement.cooperative.name
      elsif self.ledgerable.entriable_type == "Cooperative"
        self.ledgerable.entriable.name
      end
    when "Accounting::Check"
      self.ledgerable.payable
    when "Accounting::Journal"
      self.ledgerable.payable
    end
  end

  private

  def self.service_fee_account(payment_type)
    case payment_type
    when 'gyrt'
      Treasury::Account.find_by(name: 'Service Fee - GYRT')
    when 'lppi'
      Treasury::Account.find_by(name: 'Service Fee - LPPI')
    end
  end

  def self.premium_income_account(payment_type)
    case payment_type
    when 'gyrt'
      Treasury::Account.find_by(name: 'Premium Income - GYRT')
    when 'lppi'
      Treasury::Account.find_by(name: 'Premium Income - LPPI')
    end
  end

end
