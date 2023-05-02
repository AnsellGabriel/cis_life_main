class GroupRemit < ApplicationRecord
  belongs_to :agreement
  belongs_to :anniversary
  belongs_to :cooperative
  
  has_many :batches, dependent: :destroy
  accepts_nested_attributes_for :batches, allow_destroy: true
end

