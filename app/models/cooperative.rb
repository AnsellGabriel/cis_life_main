class Cooperative < ApplicationRecord
    has_many :coop_users
    has_many :coop_branches

    has_many :coop_members, dependent: :destroy
    has_many :members, through: :coop_members
    
    has_many :agreements
    has_many :group_remits

    # belongs_to :coop_type
    # belongs_to :geo_region
    # belongs_to :geo_province
    # belongs_to :geo_municipality
    # belongs_to :geo_barangay

    def to_s
      name
    end
    
    def unselected_coop_members(ids)
      coop_members.where.not(id: ids)
    end
    
    def get_fulladdress
      "#{municipality}, #{province}, #{region}"
    end
    
    

    def coop_member_details
		  coop_members.includes(:member).order('members.last_name')
    end

    def filtered_agreements(filter)
    	agreements.filtered_by_moa_no(filter).includes({anniversaries: :group_remits}, :agent, :group_remits).order(updated_at: :desc)
    end
end
