class ProductBenefit < ApplicationRecord
  belongs_to :agreement_benefit
  belongs_to :benefit
end
