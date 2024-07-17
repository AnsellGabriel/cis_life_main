class Claims::ClaimRetrieval < ApplicationRecord
    validates_presence_of :name
    def to_s 
        name
    end
end
