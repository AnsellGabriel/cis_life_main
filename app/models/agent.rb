class Agent < ApplicationRecord
    belongs_to :agent_group
  
    has_one :user, as: :userable, dependent: :destroy
    has_many :agreements
  
    accepts_nested_attributes_for :user
  
    def get_fullname 
      last_name + ', ' + first_name + ' ' + middle_name[0] + '.'
    end
  end
  