class CoopMember < ApplicationRecord
  before_save :set_full_name
  validates_presence_of :coop_branch_id, :membership_date, :cooperative_id

  scope :approved_members, -> (approved_batches) {
    joins(:batches)
    .where(batches: { id: approved_batches })
    .distinct.pluck(:id)
  }

  delegate :age, to: :member

  belongs_to :cooperative
  belongs_to :coop_branch
  belongs_to :member
  has_many :loan_batches, class_name: 'LoanInsurance::Batch', foreign_key: 'coop_member_id'
  has_many :batches
  has_many :agreements_coop_members
  has_many :agreements, through: :agreements_coop_members

  def to_s
    "#{full_name.titleize}"
  end

  def get_fullname 
    # first_letters = member.middle_name.split.map { |word| word[0] }
    member.last_name.titleize + ', ' + member.first_name.titleize + ' ' + member.middle_name.chr + '. ' + member.suffix
  end

  def set_full_name
    self.full_name = "#{member.last_name}, #{member.first_name} #{member.middle_name}"
  end
  
  def birthdate
    self.member.birth_date
  end

  def active_loans(group_remit)
    unused_ids = group_remit.loan_batches.pluck(:unused_loan_id).compact
    LoanInsurance::Batch.where(coop_member_id: self)
                        .where.not(status: :terminated)
                        .where.not(group_remit: group_remit)
                        .where.not(id: unused_ids)
  end

  def loans
    LoanInsurance::Batch.where(coop_member_id: self).order(created_at: :desc)
  end
end
