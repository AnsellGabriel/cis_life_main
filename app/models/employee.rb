class Employee < ApplicationRecord
  belongs_to :department
  has_one :user, as: :userable
end
