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


  enum rank: {
    rank_and_file: 0,
    analyst: 1,
    head: 2,
    senior_officer: 3,
    medical_director: 4
  }

  attribute :admin, :boolean, default: false
  attribute :approved, :boolean, default: false

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

  def is_treasurer?
    userable.department_id == 26
  end

  def is_mis?
    userable_type == "Employee" && userable.department_id == 15
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
