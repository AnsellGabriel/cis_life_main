class GeoMunicipality < ApplicationRecord
  belongs_to :geo_region
  belongs_to :geo_province


  def to_s
    name
  end
end
