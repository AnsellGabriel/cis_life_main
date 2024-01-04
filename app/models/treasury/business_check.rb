class Treasury::BusinessCheck < ApplicationRecord
  validates_presence_of :check_number, :check_date, :amount, :voucher_id

  alias_attribute :number, :check_number

  enum check_type: { regular: 0, manager: 1 }

  belongs_to :voucher, class_name: "Accounting::Check"

end
