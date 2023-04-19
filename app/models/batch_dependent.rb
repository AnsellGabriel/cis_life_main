class BatchDependent < ApplicationRecord
  belongs_to :batch
  belongs_to :agreement_benefit
end
