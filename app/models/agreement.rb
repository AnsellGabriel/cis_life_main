class Agreement < ApplicationRecord
    validates_presence_of :name, :premium, :coop_service_fee, :agent_service_fee
    
    belongs_to :plan
    belongs_to :cooperative
    has_many :group_remits
    has_and_belongs_to_many :coop_members

end
