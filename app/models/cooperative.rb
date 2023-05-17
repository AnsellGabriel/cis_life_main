class Cooperative < ApplicationRecord
    has_many :coop_users
    has_many :coop_branches

    has_many :coop_members, dependent: :destroy
    has_many :members, through: :coop_members
    
    has_many :agreements
    has_many :group_remits

    def unselected_coop_members(ids)
        self.coop_members.where.not(id: ids).includes(:member).order('members.last_name')
    end

    def coop_member_details
        self.coop_members.includes(:member).order('members.last_name')
    end
end
