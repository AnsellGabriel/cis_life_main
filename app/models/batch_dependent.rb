class BatchDependent < ApplicationRecord
  belongs_to :batch
  # belongs_to :agreement_benefit
  belongs_to :member_dependent
end
