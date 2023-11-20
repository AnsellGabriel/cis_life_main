class Treasury::BillingStatement < ApplicationRecord
  validates_presence_of :bs_no, :bs_date

  belongs_to :cashier_entry

  def entry_type
    'ce'
  end
end
