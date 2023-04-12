class CoopMember < ApplicationRecord
  before_validation :uppercase_fields
  validates :mobile_number, format: { with: /(\+?\d{2}?\s?\d{3}\s?\d{3}\s?\d{4})|([0]\d{3}\s?\d{3}\s?\d{4})/, message: "Invalid mobile number format" }


  validates_presence_of :coop_branch_id, :last_name, :first_name, :middle_name, :birthdate, :mobile_number, :address, :civil_status
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  belongs_to :cooperative
  belongs_to :coop_branch
  has_many :coop_member_dependents, dependent: :destroy
  has_many :coop_member_beneficiaries, dependent: :destroy

  accepts_nested_attributes_for :coop_member_beneficiaries, allow_destroy: true, reject_if: :all_blank  
  validates_associated :coop_member_beneficiaries

  def uppercase_fields
    self.last_name = self.last_name.upcase
    self.first_name = self.first_name.upcase
    self.middle_name = self.middle_name.upcase
    self.suffix = self.suffix.upcase
    # repeat the above line for each field you want to make all caps
  end
end
