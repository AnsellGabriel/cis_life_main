class CoopMember < ApplicationRecord
  belongs_to :cooperative
  belongs_to :coop_branch
  has_many :coop_member_dependents, dependent: :destroy
  has_many :coop_member_beneficiaries, dependent: :destroy
end
