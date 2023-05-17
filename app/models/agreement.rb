class Agreement < ApplicationRecord
    validates_presence_of :name
    
    belongs_to :plan
    belongs_to :agent
    belongs_to :cooperative

    has_many :agreement_benefits
    has_many :group_remits
    has_many :anniversaries
    has_and_belongs_to_many :coop_members

    def get_principal_premium
        self.agreement_benefits.find_by(insured_type: 1).product_benefit.premium
    end
    
    def get_dependent_premium
        self.agreement_benefits.find_by(insured_type: 2).product_benefit.premium
    end

    def get_coop_sf
        self.agreement_benefits[0].proposal.coop_sf
    end

end
