class Treasury::SubAccount < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :general_ledgers

  private

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
