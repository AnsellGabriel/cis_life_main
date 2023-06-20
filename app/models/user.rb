class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthablead
  belongs_to :userable, polymorphic: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

end
