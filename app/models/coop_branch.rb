class CoopBranch < ApplicationRecord
  belongs_to :cooperative
  has_many :coops
  has_many :coop_members
end
