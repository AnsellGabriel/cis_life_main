class Agreement < ApplicationRecord
  validates_presence_of :cooperative_id, :plan_id, :agent_id, :moa_no, :contestability, :nel, :nml, :entry_age_from, :entry_age_to, :exit_age, :coop_sf, :agent_sf, :minimum_participation

  scope :with_moa_like, -> (filter) { where("moa_no LIKE ?", "%#{filter}%") }
  scope :lppi, -> { find {|a| a.plan.acronym == "LPPI"} }
  scope :sii, -> { find {|a| a.plan.acronym == "SII"} }

  Comm_type = ["Gross Commission", "Net Commission"]
  Anniversary = ["Single", "Multiple", "12 Months"]

  belongs_to :plan, optional: true
  # belongs_to :proposal, optional: true
  belongs_to :agent, optional: true
  belongs_to :cooperative, optional: true

  has_many :agreement_benefits
  has_many :emp_agreements
  has_many :employees, through: :emp_agreements
  has_many :group_remits
  has_many :anniversaries
  has_many :agreements_coop_members
  has_many :coop_members, through: :agreements_coop_members
  has_many :loan_rates, class_name: "LoanInsurance::Rate"
  has_many :special_arrangements, dependent: :destroy
  has_one :agreement_proposal, dependent: :destroy
  has_one :group_proposal, through: :agreement_proposal
  accepts_nested_attributes_for :agreement_benefits, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :loan_rates, reject_if: :all_blank, allow_destroy: true

    delegate :acronym, to: :plan, prefix: true
    def to_s
      plan
    end

  def coop_name
    self.cooperative.name
  end
  # filters anniversaries based on a given set of expiry dates
  def get_filtered_anniversaries(expiry_dates)
    anniversaries.reject do |anniv|
      expiry_dates.include?(anniv.anniversary_date.strftime("%m-%d"))
    end
  end

  def active_group_remits
    group_remits.select { |gr| gr.active? }
  end

  def expired_group_remits
    group_remits.select { |gr| gr.expired? }
  end

  def renewed_group_remits
    group_remits.where(status: :renewed)
  end

  def self.filtered(params)
    joins(:cooperative, :plan).where("cooperatives.name LIKE ? OR plans.name LIKE ? OR agreements.moa_no LIKE ? OR plans.acronym LIKE ?", "%#{params}%", "%#{params}%", "%#{params}%", "%#{params}%")
  end
end
