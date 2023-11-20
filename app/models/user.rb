class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable, :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :coop_user, optional: true
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
    "#{userable.last_name}, #{userable.first_name}"
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

end
