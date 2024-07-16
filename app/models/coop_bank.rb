class CoopBank < ApplicationRecord
  before_save :upcase_details

  validates_presence_of :cooperative_id, :name, :branch, :cooperative_id
  validates :account_number, format: { with: /\A\d+\z/, message: "is not valid" }

  belongs_to :cooperative

  def upcase_details
    self.name.upcase!
    self.branch.upcase!
  end
end
