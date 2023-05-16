class Anniversary < ApplicationRecord
    belongs_to :agreement
    has_one :group_remit
end
