class Team < ApplicationRecord
  has_many :employee_teams
  has_many :employees, through: :employee_teams

  def to_s
    name
  end
end
