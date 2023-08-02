class EmpAgreement < ApplicationRecord
  belongs_to :employee
  belongs_to :agreement
end
