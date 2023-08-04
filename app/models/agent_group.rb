class AgentGroup < ApplicationRecord
    has_many :agents

    def to_s 
        name
    end
end
