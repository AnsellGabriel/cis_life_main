class GroupRemit < ApplicationRecord
  belongs_to :agreement
  belongs_to :anniversary
  
  has_many :batches, dependent: :destroy
end

