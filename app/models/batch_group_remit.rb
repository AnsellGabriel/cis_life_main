class BatchGroupRemit < ApplicationRecord
  scope :existing_members, -> (coop_member_ids) { joins(:batch).where(batch: {coop_member_id: coop_member_ids}) }

  belongs_to :batch
  belongs_to :group_remit
end
