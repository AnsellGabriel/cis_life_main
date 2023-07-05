class CoopBranch < ApplicationRecord
  before_save :to_downcase

  belongs_to :cooperative
  has_many :coop_users
  has_many :coop_members

  def to_downcase
    self.name.downcase
  end
end
