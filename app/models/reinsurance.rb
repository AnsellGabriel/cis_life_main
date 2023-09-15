class Reinsurance < ApplicationRecord
  has_many :reinsurance_batches
  has_many :loan_insurance_batches, through: :reinsurance_batches
end
