class Cooperative < ApplicationRecord
    has_many :coops
    has_many :coop_branches
    has_many :coop_members
end
