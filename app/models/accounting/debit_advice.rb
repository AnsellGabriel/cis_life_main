class Accounting::DebitAdvice < Accounting::Voucher
  validates_presence_of :treasury_account_id, :amount, :employee_id, :branch_id

  belongs_to :treasury_account, class_name: "Treasury::Account", foreign_key: :treasury_account_id
  belongs_to :employee
  belongs_to :branch

  has_many :debit_advice_journals, class_name: "Accounting::DebitAdviceJournal"
  has_many :journals, through: :debit_advice_journals
  has_many :journal_entries, as: :journable, dependent: :destroy
  has_many :voucher_requests, as: :requestable, dependent: :destroy, class_name: "Accounting::VoucherRequest"

  has_one :attachment, class_name: 'Accounting::DebitAdviceReceipt'
  has_one :jv_request, as: :requestable, dependent: :destroy, class_name: "Accounting::VoucherRequest"

  enum payout_status: {
    pending_payout: 0,
    paid: 1
  }

  def entry_type
    'da'
  end

  def payment_type
    'Debit Advice'
  end

  def voucher_type
    :debit_advice
  end

  def total_amount
    amount
  end

  def self.generate_series
    current_year_and_month = Time.now.strftime("%Y-%m")
    last_series = self.where("voucher LIKE ?", "#{current_year_and_month}%")
                  .order(:voucher).last&.voucher

    if last_series.present?
      series = last_series[0..7] + sprintf("%03d", last_series[-3..-1].to_i + 1)
    else
      series = Time.now.strftime("%Y-%m") + "-001"
    end

    series
  end

  private

  def self.ransackable_attributes(auth_object = nil)
    ["voucher"]
  end
end
