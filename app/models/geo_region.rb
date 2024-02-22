class GeoRegion < ApplicationRecord
  has_many :geo_provinces
  
  def to_s
    name
  end

end
