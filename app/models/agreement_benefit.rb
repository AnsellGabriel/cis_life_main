class AgreementBenefit < ApplicationRecord
  belongs_to :agreements
  belongs_to :plans
  belongs_to :proposals
  belongs_to :options
end
