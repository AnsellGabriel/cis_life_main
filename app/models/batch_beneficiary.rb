class BatchBeneficiary < ApplicationRecord
  belongs_to :batch
  belongs_to :member_dependent

  def to_s
    "#{member_dependent.last_name}, #{member_dependent.first_name} #{member_dependent.middle_name}".titleize + " - #{member_dependent.relationship}"
  end
end
