class CoopMember < ApplicationRecord
  validates_presence_of :coop_branch_id, :membership_date, :cooperative_id

  belongs_to :cooperative
  belongs_to :coop_branch
  belongs_to :member
  has_many :batches
  has_and_belongs_to_many :agreements

  def to_s
    "#{CoopMember.find(self.id).member.full_name}"
  end
end
