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

  # Override Devise method to prevent login if not approved
  def active_for_authentication?
    super && approved?
  end
  
end
