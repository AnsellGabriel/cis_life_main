class GroupProposal < ApplicationRecord
  belongs_to :cooperative
  belongs_to :plan
  belongs_to :plan_unit
end
