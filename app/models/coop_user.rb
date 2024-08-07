class CoopUser < ApplicationRecord
  validates_presence_of :coop_branch_id, :last_name, :first_name, :birthdate

  # VALID_PH_MOBILE_NUMBER_REGEX = /\A(09|\+639)\d{9}\z/
  # validates :mobile_number, presence: true, format: { with: VALID_PH_MOBILE_NUMBER_REGEX, message: "must be a valid Philippine mobile number" }

  belongs_to :cooperative
  belongs_to :coop_branch, optional: true
  has_one :user, as: :userable, dependent: :destroy
  # has_one :member_import_tracker, as: :trackable, dependent: :destroy
  has_one :progress_tracker, as: :trackable, dependent: :destroy
  accepts_nested_attributes_for :user

  def to_s
    get_fullname.titleize
  end

  def get_fullname
    "#{first_name} #{last_name}"
  end

  def signed_fullname
    "#{first_name} #{middle_name[0]}. #{last_name}".titleize
  end
end
