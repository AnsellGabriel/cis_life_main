class Reinsurance < ApplicationRecord
  has_many :reinsurance_members
  has_many :reinsurance_batches, through: :reinsurance_members
  has_many :members, through: :reinsurance_members
  # has_many :batches, class_name: "LoanInsurance::Batch", foreign_key: "group_remit_id", dependent: :destroy, through: :reinsurance_batches


  def set_total_prem_and_amount
    self.update(
      ri_total_amount: self.batches.sum(:loan_amount),
      ri_total_prem: self.batches.sum(:premium_due)
    )
  end

  def get_batches
    self.members
  end

  def get_members
    self.reinsurance_members
  end

  def add_members(members, retention)
    members.each do |member|
      ri_start = self.date_from
      ri_end = self.date_to

      total = member.coop_members.joins(:loan_batches).where("(loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?) OR (loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?)", ri_start, ri_start, ri_end, ri_end).sum(:loan_amount)

      if total >= retention

        ri_mem = ReinsuranceMember.find_or_initialize_by(reinsurance: self, member: member)
        ri_mem.total_loan_amount = member.total_loan_amount
        ri_mem.save!
  
        member.get_for_ri_sum(ri_mem, retention)
      end
      
    end
  end

  # def set_batches_ri_date
  #   self.reinsurance_batches.each do |batch|
  #     prev_ri = batch.reinsurance_batches.find_by(batch: batch)
  #   end
  # end

  def count_batches
    self.reinsurance_batches.count
  end

  def get_total_ri_amount(retention)
    total = 0
    self.reinsurance_members.each do |rm|
      unless (rm.batches.sum(:loan_amount) - retention) <= 0
        total += rm.batches.sum(:loan_amount) - retention
      end
    end
    return total
  end
end
