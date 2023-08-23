class AuthorityLevel < ApplicationRecord
  
  def name_max_amount
    "#{name} - #{to_currency(maxAmount)}"
  end
end
