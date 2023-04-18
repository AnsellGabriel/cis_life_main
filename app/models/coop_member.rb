class CoopMember < ApplicationRecord
  validates_presence_of :coop_branch_id, :membership_date, :cooperative_id
  validates :coop_branch_id, presence: true, exclusion: { in: [nil, "", "Select a branch"] }


  belongs_to :cooperative
  belongs_to :coop_branch
  belongs_to :member
  has_and_belongs_to_many :batches

  # has_many :coop_member_dependents, dependent: :destroy
  # has_many :coop_member_beneficiaries, dependent: :destroy

  # accepts_nested_attributes_for :coop_member_beneficiaries, allow_destroy: true, reject_if: :all_blank  
  # validates_associated :coop_member_beneficiaries
end
