class Employee < ApplicationRecord
  mount_uploader :report, ReportUploader

  belongs_to :department

  has_one :employee_team
  has_one :team, through: :employee_team
  has_one :emp_approver
  has_one :user, as: :userable, dependent: :destroy
  has_many :emp_agreements
  has_many :agreements, through: :emp_agreements
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :treasury_cashier_entries
  has_many :vouchers, class_name: "Accounting::Voucher"

  validates_presence_of :last_name, :first_name, :branch, :department_id, :designation
  # has_one :member_import_tracker, as: :trackable, dependent: :destroy

  accepts_nested_attributes_for :user

  enum branch: { head_office: 0, cagayan_de_oro: 1, iloilo: 2, davao: 3}

  ANALYSTS = Employee.joins(:user).where(department_id: [17, 23, 21, 20], user: { rank: 1 })
  HEADS = Employee.joins(:user).where(department_id: 17, user: { rank: 2 })
  APPROVER = Employee.where(id: [107, 54, 144, 29, 26])

  def to_s
    get_fullname
  end

  def get_fullname
    "#{first_name} #{middle_name[0]} #{last_name}".titleize
  end

  def get_approver
    team.employee_teams.find_by(head: true).employee
  end

  def initials_name
    "#{first_name[0]}#{middle_name[0].upcase} #{last_name.titleize}"
  end

  def signed_fullname
    "#{first_name} #{middle_name[0]}. #{last_name}".titleize
  end

  def delete_uploaded_report
    if self.report.identifier.present?
      # Delete the file using CarrierWave
      self.update!(remove_report: true)
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["first_name", "last_name"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
