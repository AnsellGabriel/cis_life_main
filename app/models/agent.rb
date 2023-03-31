class Agent < ApplicationRecord
  belongs_to :agent_group
  has_one :user, as: :userable, dependent: :destroy
  accepts_nested_attributes_for :user
end
