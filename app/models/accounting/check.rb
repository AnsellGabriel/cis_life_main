class Accounting::Check < Accounting::Voucher
  validates_presence_of :treasury_account_id, :amount#, :voucher
  before_save :format_cv_no


  # belongs_to :treasury_account, class_name: "Treasury::Account", foreign_key: :treasury_account_id
  # belongs_to :claim_request_for_payment, optional: true
  belongs_to :check_voucher_request, optional: true
  has_many :business_checks, class_name: "Treasury::BusinessCheck", foreign_key: :voucher_id, dependent: :destroy
  # has_many :general_ledgers, as: :ledgerable
  # has_many :remarks, as: :remarkable, dependent: :destroy

  # enum status: { pending: 0, posted: 1, cancelled: 2, for_approval: 3}

  def self.disbursement_book_pdf(employee_id, date_from, date_to, type)
    Reports::BooksPdfJob.perform_async(employee_id, date_from, date_to, type)
  end

  def reference
    "CV#{self.voucher}"
  end

  def entry_type
    'cv'
  end

  def total_amount
    amount
  end

  private

  def format_cv_no
    self.voucher = sprintf("%05d", self.voucher.to_i) # "00001"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["voucher"]
  end
end
