class BatchDependent < ApplicationRecord
  # before_save :set_premium
  
  belongs_to :batch
  # belongs_to :agreement_benefit
  belongs_to :member_dependent

  # private
  # def set_premium
  #   self.premium = (self.batch.agreement.agreement_benefits.find_by(insured_type: 2).premium / 12) * self.batch.group_remit.terms
  # end
end
