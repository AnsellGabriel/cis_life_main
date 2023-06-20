class Agreement < ApplicationRecord
  belongs_to :plan
  belongs_to :cooperative
  belongs_to :agent

  Comm_type = ["Gross Commission", "Net Commission"]
  Anniversary = ["Single", "Multiple", "12 Months"]
end
