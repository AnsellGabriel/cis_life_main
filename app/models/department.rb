class Department < ApplicationRecord
  has_many :employees

  def to_s
    name
  end
end
