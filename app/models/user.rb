class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable, :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :password_complexity

  # belongs_to :coop_user, optional: true
  belongs_to :userable, polymorphic: true
  has_many :user_levels
  has_many :dependent_remarks
  has_many :remarks, dependent: :destroy
  has_one :progress_tracker, as: :trackable, dependent: :destroy

  has_many :claim_remarks
  has_many :read_messages
  has_many :read_messages, through: :read_messages, source: :claim_remark
  # accepts_nested_attributes_for :ff
  delegate :initials_name, to: :userable

  enum rank: {
    rank_and_file: 0,
    analyst: 1,
    head: 2,
    senior_officer: 3,
    medical_director: 4
  }

  attribute :admin, :boolean, default: false
  attribute :approved, :boolean, default: false

  def unread_messages
    Claims::ClaimRemark.left_outer_joins(:read_messages)
           .where(coop: 1, read_messages: { id: nil })
          #  .or(Claims::ClaimRemark.left_outer_joins(:read_messages)
          #             .where.not(read_messages: { user_id: id }))
  end

  def to_s
    userable.to_s
  end

  def user_id
    id
  end

  # Override Devise method to prevent login if not approved
  def active_for_authentication?
    super && approved?
  end

  def is_accountant?
    userable.department_id == 11
  end

  def is_employee?
    userable_type == "Employee"
  end

  def is_treasurer?
    userable.department_id == 26
  end

  def is_mis?
    userable_type == "Employee" && userable.department_id == 15
  end

  def is_claims?
    userable_type == "Employee" && userable.department_id == 19
  end

  def is_und?
    userable_type == "Employee" && userable.department_id == 17
  end

  def is_auditor?
    userable_type == "Employee" && userable.department_id == 27
  end

  def is_coop_user?
    userable_type == "CoopUser"
  end

  def self.get_encoder(id)
    find(id).userable
  end

  private

  def password_complexity
    return if password.blank?

    unless password.match?(/\d/)
      errors.add :password, 'at least one digit'
    end

    unless password.match?(/[a-z]/)
      errors.add :password, 'at least one lowercase letter'
    end

    unless password.match?(/[A-Z]/)
      errors.add :password, 'at least one uppercase letter'
    end

    unless password.match?(/[[:^alnum:]]/)
      errors.add :password, 'at least one special character'
    end
  end


end
