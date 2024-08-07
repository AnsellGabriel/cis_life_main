class CoopMember < ApplicationRecord
  before_save :set_full_name
  validates_presence_of :coop_branch_id, :cooperative_id

  scope :approved_members, -> (approved_batches) {
    joins(:batches)
    .where(batches: { id: approved_batches })
    .distinct.pluck(:id)
  }

  delegate :age, to: :member

  belongs_to :cooperative
  belongs_to :coop_branch, optional: true
  belongs_to :member
  has_many :loan_batches, class_name: "LoanInsurance::Batch", foreign_key: "coop_member_id"
  has_many :batch_health_decs, through: :loan_batches
  has_many :batches
  has_many :agreements_coop_members
  has_many :agreements, through: :agreements_coop_members
  # has_many :process_claims, class_name: "Claims::ProcessClaim"
  has_many :process_claims, as: :insurable, class_name: "Claims::ProcessClaim"

  def self.ransackable_attributes(auth_object = nil)
    ["coop_branch_id", "cooperative_id", "created_at", "deceased", "full_name", "id", "member_id", "membership_date", "old_mem_code", "transferred", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["process_claims"]
  end
  
  def to_s
    "#{full_name.titleize}"
  end

  def get_fullname
    # first_letters = member.middle_name.split.map { |word| word[0] }
    member.full_name
  end

  def set_full_name
    self.full_name = "#{member.last_name}, #{member.first_name} #{member.middle_name}"
  end


  def birthdate
    self.member.birth_date
  end

  def active_loans(group_remit, loan_type = nil)
    unused_ids = group_remit.batches.pluck(:unused_loan_id).compact

    active_loans = LoanInsurance::Batch.joins(:group_remit)
                        .where(group_remit: { status: :paid })
                        .where(coop_member_id: self)
                        .where(insurance_status: :approved)
                        .where.not(status: :expired)
                        .where.not(status: :terminated)
                        .where.not(group_remit: group_remit)
                        .where.not(id: unused_ids)

    if loan_type.present?
      active_loans = active_loans.where(loan: loan_type)
    else
      active_loans
    end

  end

  def loans
    LoanInsurance::Batch.where(coop_member_id: self).order(created_at: :desc)
  end

  def with_coverages?
    # Retrieve all batches of the coop_member
    member_batches = self.batches
    loan_batches = self.loan_batches

    # Retrieve all group_remits associated with the member_batches
    group_remits = GroupRemit.joins(:batches).where(batches: { id: member_batches }).where(status: ["paid", "expired"]).distinct
    loan_remits =  GroupRemit.joins(:loan_batches).where(loan_batches: { id: loan_batches }).where(status: ["paid", "expired"]).distinct
    paid_group_remits = group_remits + loan_remits
    # Filter the group_remits with a status of "paid"
    paid_group_remits.present?
  end

  def get_max_effectivity(ri_start, ri_end)
    dates = loan_batches.where.not(loan_insurance_batches: { status: [:terminated, :expired] }).where("(loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?) OR (loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?)", ri_start, ri_start, ri_end, ri_end).pluck(:effectivity_date)
    dates.max
  end
  
  def get_ri_batches(ri_start, ri_end)
    loan_batches.where.not(loan_insurance_batches: { status: [:terminated, :expired] }).where("(loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?) OR (loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?)", ri_start, ri_start, ri_end, ri_end)
  end
end
