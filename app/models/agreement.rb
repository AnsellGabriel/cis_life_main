class Agreement < ApplicationRecord
    validates_presence_of :name
    
    belongs_to :plan
    belongs_to :agent
    belongs_to :cooperative

    has_many :agreement_benefits
    has_many :group_remits
    has_many :anniversaries
    has_and_belongs_to_many :coop_members

end
