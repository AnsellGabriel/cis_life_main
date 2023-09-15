class ReinsuranceBatch < ApplicationRecord
  belongs_to :reinsurance
  belongs_to :loan_batches
end
