class GeoBarangay < ApplicationRecord
  belongs_to :geo_region
  belongs_to :geo_province
  belongs_to :geo_municipality

  def to_s 
    name
  end
end
