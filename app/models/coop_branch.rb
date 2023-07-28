class CoopBranch < ApplicationRecord
  before_save :to_upcase

  belongs_to :cooperative
  belongs_to :coop_type, optional: true
  has_many :coop_users
  has_many :coop_members
  belongs_to :geo_region, optional: true
  belongs_to :geo_province, optional: true
  belongs_to :geo_municipality, optional: true
  belongs_to :geo_barangay, optional: true


  def get_address 
    geo_province.name + ', ' + geo_municipality.name + ', ' + geo_barangay.name + ', ' + 
    "#{self.street}"
    # "#{self.street}" + ', ' geo_barangay.name + ', ' + geo_municipality.name + ', ' + geo_province.name
  end
  
  def to_upcase
    name.upcase
  end
end
