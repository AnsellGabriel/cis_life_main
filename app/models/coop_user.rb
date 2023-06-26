class CoopUser < ApplicationRecord
  validates_presence_of :coop_branch_id, :last_name, :first_name, :middle_name, :birthdate

  VALID_PH_MOBILE_NUMBER_REGEX = /\A(09|\+639)\d{9}\z/
  validates :mobile_number, presence: true, format: { with: VALID_PH_MOBILE_NUMBER_REGEX, message: "must be a valid Philippine mobile number" }

  belongs_to :cooperative
  belongs_to :coop_branch
  has_one :user, as: :userable, dependent: :destroy
  accepts_nested_attributes_for :user

  def to_s
    get_fullname.titleize
  end

  def get_fullname
    "#{first_name} #{last_name}"
  end
end
