class CoopBank < ApplicationRecord
  before_save :upcase_details

  validates_presence_of :name, :branch
  # validates :account_number, format: { with: /\A\d+\z/, message: "is not valid" }

  belongs_to :cooperative
  belongs_to :bank

  def upcase_details
    self.name.upcase!
    self.branch.upcase!
  end

  def to_s 
    name
  end
end
