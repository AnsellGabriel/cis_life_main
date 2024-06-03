class Team < ApplicationRecord
  has_many :employee_teams
  has_many :employees, through: :employee_teams
  has_many :emp_agreements
  has_many :agreements, through: :emp_agreements
  has_many :notifications, as: :notifiable, dependent: :destroy

  def to_s
    name
  end

  def get_team_head(val=nil)
    if val == "name"
      employee_teams.find_by(head: true).employee
    elsif val == "pos"
      employee_teams.find_by(head: true).employee.designation
    end
  end

  def get_team_members
    employee_teams.where.not(head: true)
  end
end
