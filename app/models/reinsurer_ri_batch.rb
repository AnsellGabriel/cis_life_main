class ReinsurerRiBatch < ApplicationRecord
  belongs_to :reinsurance_batch
  belongs_to :reinsurer
end
