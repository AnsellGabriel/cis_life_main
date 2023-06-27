class ProcessClaim < ApplicationRecord
  belongs_to :cooperative
  belongs_to :agreement
  belongs_to :batch
end
