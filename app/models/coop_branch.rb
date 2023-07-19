class CoopBranch < ApplicationRecord
  before_save :to_upcase

  belongs_to :cooperative
  has_many :coop_users
  has_many :coop_members

  def to_upcase
    name.upcase
  end
end
