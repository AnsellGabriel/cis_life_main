class ClaimType < ApplicationRecord
    validates_presence_of :name
    has_many :claim_type_benefits, dependent: :destroy 
    has_many :claim_type_documents, dependent: :destroy
    
    def to_s 
        name
    end
end
