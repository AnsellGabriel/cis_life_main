class CoopMember < ApplicationRecord
  belongs_to :cooperative
  belongs_to :coop_branch
  has_many :coop_member_dependents, dependent: :destroy
  has_many :coop_member_beneficiaries, dependent: :destroy
  accepts_nested_attributes_for :coop_member_beneficiaries, allow_destroy: true, reject_if: :all_blank  
end
