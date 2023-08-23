class DependentHealthDec < ApplicationRecord
  belongs_to :batch_dependent
  belongs_to :answerable, polymorphic: true
end
