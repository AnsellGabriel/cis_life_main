class BatchBeneficiary < ApplicationRecord
  attr_accessor :claims

  belongs_to :batch
  belongs_to :member_dependent

  delegate :full_name, to: :member_dependent

  def to_s
    beneficiary = BatchBeneficiary.includes(:member_dependent).find(self.id)
    "#{beneficiary.member_dependent.last_name}, #{beneficiary.member_dependent.first_name} #{beneficiary.member_dependent.middle_name}".titleize + " - #{beneficiary.member_dependent.relationship}"
  end
end
