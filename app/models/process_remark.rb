class ProcessRemark < ApplicationRecord
  belongs_to :process_coverage
  belongs_to :user, polymorphic: true
end
