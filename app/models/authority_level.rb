class AuthorityLevel < ApplicationRecord
  validates_presence_of :name, :entry_type, :maxAmount

  def name_max_amount
    "#{name} - #{to_currency(maxAmount)}"
  end

  enum entry_type: {
    claim: 0,
    underwriting: 1,
    accounting: 2,
    treasury: 3
  }
end

