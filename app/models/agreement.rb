class Agreement < ApplicationRecord
    validates_presence_of :name, :premium, :coop_service_fee, :agent_service_fee
    
    has_one :group_remit
end
