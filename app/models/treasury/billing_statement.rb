class Treasury::BillingStatement < ApplicationRecord
  belongs_to :cashier_entry
end
