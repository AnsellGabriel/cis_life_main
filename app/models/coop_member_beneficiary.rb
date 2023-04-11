class CoopMemberBeneficiary < ApplicationRecord
  validates_presence_of :coop_member_id, :last_name, :first_name, :middle_name, :birthdate, :relationship
  belongs_to :coop_member
end
