class CoopMember < ApplicationRecord
  before_save :set_full_name
  validates_presence_of :coop_branch_id, :membership_date, :cooperative_id

  belongs_to :cooperative
  belongs_to :coop_branch
  belongs_to :member
  has_many :batches
  has_and_belongs_to_many :agreements

  def to_s
    "#{full_name}"
  end

  def set_full_name
    self.full_name = "#{member.last_name}, #{member.first_name} #{member.middle_name}"
  end
  
end
