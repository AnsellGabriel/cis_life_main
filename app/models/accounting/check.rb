class Accounting::Check < Accounting::Voucher
  validates_presence_of :treasury_account_id, :amount
  before_save :format_cv_no

  has_many :business_checks, class_name: "Treasury::BusinessCheck", foreign_key: :voucher_id, dependent: :destroy

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
