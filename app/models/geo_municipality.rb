class GeoMunicipality < ApplicationRecord
  belongs_to :geo_region
  belongs_to :geo_province
  has_many :geo_barangays


  def to_s
    name
  end
end
