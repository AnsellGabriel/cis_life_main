class GeoProvince < ApplicationRecord
  belongs_to :geo_region

  def to_s 
    name
  end
end
