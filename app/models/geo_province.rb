class GeoProvince < ApplicationRecord
  belongs_to :geo_region
  has_many :geo_municipalities

  def to_s
    name
  end
end
