class Member < ApplicationRecord
  before_validation :uppercase_fields

  VALID_PH_MOBILE_NUMBER_REGEX = /\A(09|\+639)\d{9}\z/
  validates :mobile_number, presence: true, format: { with: VALID_PH_MOBILE_NUMBER_REGEX, message: "must be a valid Philippine mobile number" }
  validates :work_phone_number, allow_blank: true, format: { with: VALID_PH_MOBILE_NUMBER_REGEX, message: "must be a valid Philippine mobile number" }
  validates_presence_of :last_name, :first_name, :middle_name, :birth_date, :address, :civil_status
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # belongs_to :cooperative
  # belongs_to :coop_branch
  # has_many :coop_member_dependents, dependent: :destroy
  # has_many :coop_member_beneficiaries, dependent: :destroy
  has_many :coop_members
  accepts_nested_attributes_for :coop_members

  # accepts_nested_attributes_for :coop_member_beneficiaries, allow_destroy: true, reject_if: :all_blank  
  # validates_associated :coop_member_beneficiaries

  def uppercase_fields
    self.last_name = self.last_name.upcase
    self.first_name = self.first_name.upcase
    self.middle_name = self.middle_name.upcase
    self.suffix = self.suffix.upcase
    # repeat the above line for each field you want to make all caps
  end
end
