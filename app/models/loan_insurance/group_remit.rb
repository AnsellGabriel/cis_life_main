class LoanInsurance::GroupRemit < GroupRemit
  validates :type, inclusion: { in: ['LoanInsurance::GroupRemit'], message: 'is not valid' }

  has_many :batches, class_name: "LoanInsurance::Batch", foreign_key: "group_remit_id", dependent: :destroy

  def terminate_unused_batches(current_user)
    unused_ids = batches.pluck(:unused_loan_id).compact
    unused_batches = LoanInsurance::Batch.where(id: unused_ids)
    unused_batches.update_all(insurance_status: :terminated)
    unused_batches.each do |batch|
      batch.remarks.create(remark: "Insurance terminated, tagged as unused by #{current_user.userable.to_s} on #{Date.today.strftime("%B %d, %Y")}", user: current_user, remarkable: batch, status: :terminated, batch_status: 'terminated')
    end
  end

  def total_unused_premium
    batches.sum(:unused)
  end

  def total_premium_due
    batches.sum(:premium_due)
  end

end
