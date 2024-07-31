class Team < ApplicationRecord
  has_many :employee_teams
  has_many :employees, through: :employee_teams
  has_many :emp_agreements
  has_many :agreements, through: :emp_agreements
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :process_coverages
  belongs_to :branch

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

  def for_assignment_count
    process_coverages.where(status: :for_process).where(processor: nil).count
  end

  def for_process_count
    process_coverages.where(status: :for_process).where.not(processor: nil).count
  end

  def approved_count
    process_coverages.where(status: :approved).count
  end
end
