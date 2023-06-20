class Plan < ApplicationRecord
    has_many :agreement_benefits
    def to_s 
        name
    end
end
