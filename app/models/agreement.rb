class Agreement < ApplicationRecord    
    scope :filtered_by_moa_no, -> (filter) { where("moa_no LIKE ?", "%#{filter}%") }

    Comm_type = ["Gross Commission", "Net Commission"]
    Anniversary = ["Single", "Multiple", "12 Months"]

    belongs_to :plan
    belongs_to :proposal
    belongs_to :agent
    belongs_to :cooperative

    has_many :agreement_benefits
    has_many :group_remits
    has_many :anniversaries
    has_and_belongs_to_many :coop_members

    def get_coop_sf
      proposal.coop_sf
    end

    # filters anniversaries based on a given set of expiry dates
    def get_filtered_anniversaries(expiry_dates)
			anniversaries.reject do |anniv|
				expiry_dates.include?(anniv.anniversary_date.strftime("%m-%d"))
			end
		end

    def active_group_remits
      group_remits.map { |gr| gr if gr.status == 'active'}
    end

    def expired_group_remits
      group_remits.map { |gr| gr if gr.status == 'expired'}
    end

    def renewed_group_remits
      group_remits.where(status: :renewed)
    end

    def batches
      
    end
end
