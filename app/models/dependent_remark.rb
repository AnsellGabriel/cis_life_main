class DependentRemark < ApplicationRecord
  attr_accessor :group_remit_id, :process_coverage_id

  enum status: {
    pending: 0,
    denied: 1,
    md_reco: 2,
    request: 3
  }

  belongs_to :batch_dependent
  belongs_to :userable, polymorphic: true
end
