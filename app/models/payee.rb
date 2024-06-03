class Payee < ApplicationRecord
  validates_presence_of :name, :address

  private

  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end
end
