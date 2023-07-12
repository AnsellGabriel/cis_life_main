class AgreementsCoopMember < ApplicationRecord
  belongs_to :agreement
  belongs_to :coop_member
end
