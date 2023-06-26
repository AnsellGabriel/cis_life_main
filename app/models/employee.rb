class Employee < ApplicationRecord
  belongs_to :department
  has_one :user, as: :userable, dependent: :destroy
  accepts_nested_attributes_for :user

  def to_s
    get_fullname
  end

  def get_fullname
    "#{last_name}, #{first_name}, #{middle_name[0]}.".titleize
    
  end
  
end
