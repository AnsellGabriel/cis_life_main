class Accounting::Check < Accounting::Voucher
  validates_presence_of :treasury_account_id, :amount, :voucher

  belongs_to :treasury_account, class_name: "Treasury::Account", foreign_key: :treasury_account_id
  has_many :business_checks, class_name: "Treasury::BusinessCheck", foreign_key: :voucher_id, dependent: :destroy
  has_many :general_ledgers, as: :ledgerable

  enum status: { pending: 0, posted: 1, cancelled: 2 }

  def entry_type
    'cv'
  end
end
