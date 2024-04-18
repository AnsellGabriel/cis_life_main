class Treasury::BusinessCheck < ApplicationRecord
  validates_presence_of :check_number, :check_date, :amount, :voucher_id

  alias_attribute :number, :check_number

  enum check_type: { regular: 0, manager: 1 }
  enum status: {unclaimed: 0, claimed: 1}

  belongs_to :voucher, class_name: "Accounting::Check"

  private

  def self.ransackable_attributes(auth_object = nil)
    ["check_number"]
  end
end
