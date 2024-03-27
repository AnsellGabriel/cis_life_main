class Cooperative < ApplicationRecord
  before_save :upcase_name

  has_many :coop_users
  has_many :coop_branches

  has_many :coop_members, dependent: :destroy
  has_many :members, through: :coop_members

  has_many :agreements
  has_many :plans, through: :agreements
  has_many :agreements
  has_many :group_remits, through: :agreements
  has_many :batches, through: :group_remits
  has_many :process_claims
  has_many :claim_coverages, through: :process_claims
  has_many :denied_enrollees
  has_many :notifications, as: :notifiable, dependent: :destroy

  has_many :check_vouchers, as: :payable, class_name: "Accounting::Check", dependent: :destroy
  has_many :cashier_entries, as: :entriable, class_name: "Treasury::CashierEntry", dependent: :destroy
  has_many :loans, class_name: "LoanInsurance::Loan"

  belongs_to :coop_type, optional: true
  belongs_to :geo_region, optional: true
  belongs_to :geo_province, optional: true
  belongs_to :geo_municipality, optional: true
  belongs_to :geo_barangay, optional: true

  def get_age_demo(type)
    case type
    when "regular"
      eighteen_years_ago = 18.years.ago.to_date - 1.day
      sixty_five_years_ago = 65.years.ago.to_date - 1.day
      members.where(birth_date: ..eighteen_years_ago).where(birth_date: sixty_five_years_ago..).count
    when "overage"
      overage_ago = 66.years.ago.to_date
      members.where(birth_date: ..overage_ago).count
    end
  end

  def get_job_demo
    members.group(:occupation).count.to_a
  end
  

  def to_s
    name
  end

  def get_address
    # unless geo_province_id.nil? && geo_municipality_id.nil? && geo_barangay_id.nil?
    #   "#{street}, #{geo_municipality.name}, #{geo_province.name}, #{geo_region.name}"
    # end
    street = self.street if !self.street.blank?

    [street, geo_barangay&.name, geo_municipality&.name, geo_province&.name, geo_region&.name].compact.join(", ")
  end

  def unselected_coop_members(ids)
    coop_members.where.not(id: ids)
  end

  def get_fulladdress
    "#{street}, #{municipality}, #{province}, #{region}"
  end

  def coop_member_details
    coop_members.includes(:member).order("members.last_name")
  end

  def filtered_agreements(filter)
    agreements.with_moa_like(filter).includes({anniversaries: :group_remits}, :agent, :group_remits).order(updated_at: :desc)
  end

  private

  def upcase_name
    self.name = name.upcase if name.present?
  end
end
