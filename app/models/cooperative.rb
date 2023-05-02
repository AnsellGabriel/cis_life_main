class Cooperative < ApplicationRecord
    has_many :coop_users
    has_many :coop_branches
    has_many :coop_members
    
    has_many :agreements
    has_many :group_remits
end
