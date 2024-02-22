class AgreementProposal < ApplicationRecord
  belongs_to :agreement
  belongs_to :group_proposal
end
