class Actuarial::ReserveBatch < ApplicationRecord
  belongs_to :reserve, class_name: "Actuarial::Reserve", foreign_key: "actuarial_reserve_id"
  # belongs_to :batch
  belongs_to :batchable, polymorphic: true
end
