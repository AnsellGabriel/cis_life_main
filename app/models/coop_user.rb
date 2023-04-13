class CoopUser < ApplicationRecord
  validates_presence_of :coop_branch_id, :last_name, :first_name, :middle_name, :birthdate, :mobile_number

  belongs_to :cooperative
  belongs_to :coop_branch
  has_one :user, as: :userable, dependent: :destroy
  accepts_nested_attributes_for :user
end
