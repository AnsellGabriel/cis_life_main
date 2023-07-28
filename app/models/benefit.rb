class Benefit < ApplicationRecord
    has_many :product_benefits

    def to_s 
        name
    end
end
