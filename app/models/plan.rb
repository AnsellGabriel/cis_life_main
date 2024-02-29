class Plan < ApplicationRecord
  validates_presence_of :name

  has_many :agreement_benefits

  def to_s
    name
  end
end
