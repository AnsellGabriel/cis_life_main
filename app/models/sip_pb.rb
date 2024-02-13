class SipPb < ApplicationRecord
  belongs_to :sip_ab
  belongs_to :benefit
  belongs_to :plan_unit
end
