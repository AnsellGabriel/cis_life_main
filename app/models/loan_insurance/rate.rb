class LoanInsurance::Rate < ApplicationRecord
  validates_presence_of :min_age, :max_age, :annual_rate, :min_amount, :max_amount, :coop_sf, :agent_sf, :nel, :nml, :contestability

  belongs_to :agreement
  has_many :batches, class_name: "LoanInsurance::Batch", foreign_key: "loan_insurance_rate_id"
  has_many :details, class_name: "LoanInsurance::Detail"


  # def self.get_rate(id)
  #   # .find_by(id: batch.loan_insurance_rate_id).monthly_rate
  # end

  def set_rate
    update(monthly_rate: annual_rate / 12, daily_rate: annual_rate / 365)
    # monthly_rate: annual_rate / 12
    # daily_rate: annual_rate / 365
  end
end
