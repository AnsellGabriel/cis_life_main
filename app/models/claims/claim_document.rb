class Claims::ClaimDocument < ApplicationRecord
    has_many :claim_document_requests
    validates_presence_of :name

    def to_s
        name
    end
end
