class ProcessCoverage < ApplicationRecord
  belongs_to :group_remit
  belongs_to :agent, optional: true
  has_many :process_remarks

  enum status: {
    for_process: 0,
    pending: 1,
    approved: 2,
    denied: 3
  }

  def set_default_attributes
    self.status = :for_process
    self.approved_count = 0
    self.approved_total_coverage = 0
    self.approved_total_prem = 0
    self.denied_count = 0
    self.denied_total_coverage = 0
    self.denied_total_prem = 0
  end
  
end
