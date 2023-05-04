class BatchDependent < ApplicationRecord
  before_save :set_premium
  
  belongs_to :batch
  # belongs_to :agreement_benefit
  belongs_to :member_dependent

  private
  def set_premium
    self.premium = self.batch.premium
  end
end
