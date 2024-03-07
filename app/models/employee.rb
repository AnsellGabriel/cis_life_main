class Employee < ApplicationRecord
  belongs_to :department
  has_one :emp_approver
  has_many :emp_agreements
  has_many :agreements, through: :emp_agreements
  has_one :user, as: :userable, dependent: :destroy
  validates_presence_of :last_name, :first_name
  # has_one :member_import_tracker, as: :trackable, dependent: :destroy


  accepts_nested_attributes_for :user

  ANALYSTS = Employee.joins(:user).where(department_id: 17, user: { rank: 1 })
  HEADS = Employee.joins(:user).where(department_id: 17, user: { rank: 2 })

  def to_s
    get_fullname
  end

  def get_fullname
    "#{last_name}, #{first_name}, #{middle_name[0]}.".titleize
  end

  def initials_name
    "#{first_name[0]}#{middle_name[0].upcase} #{last_name.titleize}"
  end

  def signed_fullname
    "#{first_name} #{middle_name[0]}. #{last_name}".titleize
  end

end
