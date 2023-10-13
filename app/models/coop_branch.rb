class CoopBranch < ApplicationRecord
  before_save :to_upcase

  has_many :coop_users
  has_many :coop_members
  belongs_to :cooperative
  belongs_to :coop_type, optional: true
  belongs_to :geo_region, optional: true
  belongs_to :geo_province, optional: true
  belongs_to :geo_municipality, optional: true
  belongs_to :geo_barangay, optional: true

  def to_s
    name
  end

  def get_address
    unless geo_province.nil? && geo_municipality.nil? && geo_barangay.nil?
      geo_province.name + ', ' + geo_municipality.name + ', ' + geo_barangay.name + ', ' +
      "#{self.street}"
    end
    # "#{self.street}" + ', ' geo_barangay.name + ', ' + geo_municipality.name + ', ' + geo_province.name
  end

  def to_upcase
    name.upcase
  end
end
