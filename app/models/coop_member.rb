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
  belongs_to :coop_branch
  belongs_to :member
  has_many :loan_batches, class_name: "LoanInsurance::Batch", foreign_key: "coop_member_id"
  has_many :batches
  has_many :agreements_coop_members
  has_many :agreements, through: :agreements_coop_members
  has_many :process_claims, as: :claimable

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
end
