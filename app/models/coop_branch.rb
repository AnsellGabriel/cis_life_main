class CoopBranch < ApplicationRecord
  belongs_to :cooperative
  has_many :coop_users
  has_many :coop_members
end
