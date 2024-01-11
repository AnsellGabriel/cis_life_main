class ReinsuranceBatch < ApplicationRecord
  belongs_to :reinsurance_member
  belongs_to :batch, class_name: "LoanInsurance::Batch"
  has_one :reinsurer_ri_batch
  # belongs_to :batchable, polymorphic: true
  
end
