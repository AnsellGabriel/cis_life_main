class CoopMember < ApplicationRecord
  validates_presence_of :coop_branch_id, :last_name, :first_name, :middle_name, :birthdate, :mobile_number, :email
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  belongs_to :cooperative
  belongs_to :coop_branch
  has_many :coop_member_dependents, dependent: :destroy
  has_many :coop_member_beneficiaries, dependent: :destroy
  accepts_nested_attributes_for :coop_member_beneficiaries, allow_destroy: true, reject_if: :all_blank  
end
