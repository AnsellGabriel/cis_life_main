class Plan < ApplicationRecord
  validates_presence_of :name

  has_many :agreement_benefits

  GROUP_PLANS = Plan.where(acronym: ["SIP", "SII", "GBLISS", "KOOPamilya"])

  def to_s
    name
  end
end
