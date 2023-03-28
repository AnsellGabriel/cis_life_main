class Coop < ApplicationRecord
  belongs_to :cooperative
  belongs_to :coop_branch
  has_one :user, as: :userable
end
