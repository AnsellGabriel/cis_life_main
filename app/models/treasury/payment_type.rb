class Treasury::PaymentType < ApplicationRecord
  before_save :format_name

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  private

  def format_name
    self.name = self.name.squish.upcase
  end
end
