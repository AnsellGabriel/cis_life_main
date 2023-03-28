class Agent < ApplicationRecord
  belongs_to :agent_group
  has_one :user, as: :userable

end
