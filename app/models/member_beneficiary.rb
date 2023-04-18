class MemberBeneficiary < ApplicationRecord
  belongs_to :member
  belongs_to :batch
end
