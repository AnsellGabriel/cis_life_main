class Cooperative < ApplicationRecord
  belongs_to :coop_type
  belongs_to :geo_region
  belongs_to :geo_province
  belongs_to :geo_municipality
  belongs_to :geo_barangay

  def get_fulladdress 
    geo_region.name + ', ' + geo_province.name + ', ' + geo_municipality.name + ', ' + geo_barangay.name + ' ' + street
  end
end
