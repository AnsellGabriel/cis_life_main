class LoanInsurance::GroupRemit < GroupRemit
  validates :type, inclusion: { in: ["LoanInsurance::GroupRemit"], message: "is not valid" }

  has_many :batches, class_name: "LoanInsurance::Batch", foreign_key: "group_remit_id", dependent: :destroy
  # has_many :payments, as: :payable, dependent: :destroy, class_name: "Payment"

  def terminate_unused_batches(current_user)
    unused_ids = batches.pluck(:unused_loan_id).compact
    unused_batches = LoanInsurance::Batch.where(id: unused_ids).includes(coop_member: :member)
    # unused_batches.update_all(insurance_status: :terminated)
    unused_batches.each do |batch|
      member = batch.coop_member.member
      member.update!(total_loan_amount: member.total_loan_amount - batch.loan_amount)
      member.update!(for_reinsurance: false) if member.total_loan_amount < 550_000

      batch.update!(terminate_date: Date.today)
      batch.remarks.create(remark: "Insurance terminated, tagged as unused by system on #{Date.today.strftime("%B %d, %Y")}", user: current_user, remarkable: batch, status: :terminated,
batch_status: "terminated")
    end
  end

  def set_total_premiums_and_fees
    self.gross_premium = approved_premium_due
    self.coop_commission = approved_coop_commissions
    self.agent_commission = approved_agent_commissions
    self.net_premium = approved_premium_due - approved_coop_commissions - approved_agent_commissions
    self.save!
  end

  def approved_agent_commissions
    batches.approved.sum(:agent_sf_amount)
  end

  def approved_coop_commissions
    batches.approved.sum(:coop_sf_amount)
  end

  def approved_premium_due
    batches.approved.sum(:premium_due)
  end

  def coop_net_premium
    approved_premium_due - approved_coop_commissions
  end

  def total_unused_premium
    batches.sum(:unused)
  end

  def total_gross_premium
    batches.sum(:premium)
  end

  def total_excess_premium
    batches.sum(:excess)
  end

  def total_loan_amount
    batches.sum(:loan_amount)
  end

  def total_premium_due
    batches.sum(:premium_due)
  end

  def payments
    Payment.where(payable_type: "LoanInsurance::GroupRemit", payable_id: self.id)
  end

  def update_members_total_loan
    batches = self.batches.approved.includes(coop_member: :member)

    batches.each do |batch|
      member = batch.coop_member.member

      member.update!(total_loan_amount: member.total_loan_amount + batch.loan_amount)
      member.update!(for_reinsurance: true) if member.total_loan_amount >= 550_000
    end
  end




end
