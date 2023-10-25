class Accounting::Check < Accounting::Voucher
  validates_presence_of :treasury_account_id, :amount

  belongs_to :account, class_name: 'Treasury::Account', foreign_key: :treasury_account_id
end
