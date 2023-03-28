class CoopBranch < ApplicationRecord
  belongs_to :cooperative
  has_many :coops
end
