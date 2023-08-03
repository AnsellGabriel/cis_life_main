class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable, :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :userable, polymorphic: true
  has_many :user_levels

  enum rank: {
    rank_and_file: 0,
    analyst: 1,
    head: 2,
    senior_officer: 3
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
  
end
