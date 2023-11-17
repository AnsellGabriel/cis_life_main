class Actuarial::ReserveBatch < ApplicationRecord
  belongs_to :reserve, class_name: "Actuarial::Reserve", foreign_key: "actuarial_reserve_id"
  # belongs_to :batch
  belongs_to :batchable, polymorphic: true


  def get_coverage(batch)
    if batch.class.name == "LoanInsurance::Batch"
      batchable.loan_amount
    else
      ProductBenefit.get_life_cov(batch)
    end
  end

  def get_other_terms(batch)
    if batch.class.name == "LoanInsurance::Batch"
      batch.terms
    else
      ((batch.expiry_date - batch.effectivity_date) / 30).to_i
    end
  end

  def get_rate(batch)
    if batch.class.name == "LoanInsurance::Batch"
      batch.rate.annual_rate
    else
      ProductBenefit.get_premium(batch)
    end
  end
end
