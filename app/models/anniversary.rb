class Anniversary < ApplicationRecord
    belongs_to :agreement
    has_many :group_remits
end
