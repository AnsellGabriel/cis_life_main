class AgreementBenefit < ApplicationRecord
  belongs_to :agreement, optional: true
  belongs_to :plan, optional: true
  belongs_to :proposal, optional: true
  belongs_to :option, optional: true

  InsuredType = ["Principal", "Dependent"]
end
