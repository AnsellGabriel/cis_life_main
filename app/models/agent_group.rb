class AgentGroup < ApplicationRecord
  validates_presence_of :name

  has_many :agents

  def to_s
    name
  end
end
