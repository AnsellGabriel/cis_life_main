class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable, :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :userable, polymorphic: true

  
  attribute :admin, :boolean, default: false
  attribute :approved, :boolean, default: false

  # Override Devise method to prevent login if not approved
  def active_for_authentication?
    super && approved?
  end
  
end
