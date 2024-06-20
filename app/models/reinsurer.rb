class Reinsurer < ApplicationRecord
  has_many :reinsurer_ri_batches

  def to_s 
    short_name
  end
end
