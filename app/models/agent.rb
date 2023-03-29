class Agent < ApplicationRecord
  belongs_to :agent_group
  has_one :user, as: :userable, dependent: :destroy

  # allows this model to accept attributes from the user model
  accepts_nested_attributes_for :user
end
