class Actuarial::Reserve < ApplicationRecord
  attr_accessor :n_date
  self.table_name = "actuarial_reserves"
  belongs_to :plan
  has_many :reserve_batches, class_name: 'Actuarial::ReserveBatch', foreign_key: 'actuarial_reserve_id' 
  has_many :batches#, class_name: "LoanInsurance::Batch", dependent: :destroy, through: :reserve_batches


  DATES = (Date.today.year - 2..Date.today.year).to_a
  # DATES = (2010..2012)

  def self.select_dates
    DATES
  end

  def update_totals
    self.update(
      total_unearned_prem: self.reserve_batches.sum(:unearned_prem),
      total_first_advance_prem: self.reserve_batches.sum(:first_adv_prem),
      total_second_advance_prem: self.reserve_batches.sum(:second_adv_prem),
      total_reserve: self.reserve_batches.sum(:reserve_amt),
      total_unearned_pr: self.reserve_batches.sum(:unearned_pr),
      total_first_advance_pr: self.reserve_batches.sum(:first_adv_pr),
      total_second_advance_pr: self.reserve_batches.sum(:second_adv_pr),
      total_reserve_ret: self.reserve_batches.sum(:reserve_ret_amt)
    )
  end

  def set_default_dates(year)
    n_date = Date.new(year.to_i, 12, 31)

    self.first_term = n_date
    self.second_term = self.first_term + 1.year
    self.third_term = self.second_term + 1.year
  end

  def get_reserve_batches
    if self.plan.acronym == "LPPI"
      batches = LoanInsurance::Batch.get_reserve_batches(self.first_term)
    else
      # batches = Batch.get_reserve_batches(self.first_term)
      batches = Batch.get_reserves(self.first_term)
    end

    batches.each do |batch|
      r_batch = Actuarial::ReserveBatch.find_or_initialize_by(reserve: self, batchable_id: batch.id, batchable_type: batch.class.name)
      r_batch.term = batch.terms
      r_batch.rate = LoanInsurance::Rate.find_by(id: batch.loan_insurance_rate_id).monthly_rate
      r_batch.coverage_less_ri = batch.loan_amount >= 550000 ? 550000 : batch.loan_amount
      r_batch.prem_less_ri = batch.loan_amount >= 550000 ? (((r_batch.coverage_less_ri / 1000) * r_batch.rate) * r_batch.term) : batch.premium
      r_batch.duration = (batch.expiry_date - batch.effectivity_date).to_i
      r_batch.first_term = batch.expiry_date.year > self.second_term.year ? 365 : batch.expiry_date - self.first_term
      if batch.expiry_date.year >= self.third_term.year
        if batch.expiry_date.year <= self.third_term.year
          r_batch.second_term = batch.expiry_date - self.second_term
        else
          r_batch.second_term = 365
        end
      else
        r_batch.second_term = 0
      end
      r_batch.third_term = batch.expiry_date.year > self.third_term.year ? batch.expiry_date - self.third_term : 0
      r_batch.unearned_prem = ((r_batch.prem_less_ri * r_batch.first_term) / r_batch.duration)
      r_batch.first_adv_prem = ((r_batch.prem_less_ri * r_batch.second_term) / r_batch.duration)
      r_batch.second_adv_prem = ((r_batch.prem_less_ri * r_batch.third_term) / r_batch.duration)
      r_batch.reserve_amt = ((r_batch.unearned_prem + r_batch.first_adv_prem + r_batch.second_adv_prem) * 0.50)
      r_batch.cov_less_ret = batch.loan_amount <= 550000 ? 0 : batch.loan_amount - 550000
      r_batch.prem_less_ret = batch.premium - r_batch.prem_less_ri
      r_batch.unearned_pr = (r_batch.prem_less_ret * r_batch.first_term) / r_batch.duration
      r_batch.first_adv_pr = (r_batch.prem_less_ret * r_batch.second_term) / r_batch.duration
      r_batch.second_adv_pr = (r_batch.prem_less_ret * r_batch.third_term) / r_batch.duration
      r_batch.reserve_ret_amt = ((r_batch.unearned_pr + r_batch.first_adv_pr + r_batch.second_adv_pr) * 0.5)
      r_batch.save!
    end
  end
end
