class BatchHealthDec < ApplicationRecord
  belongs_to :batch
  belongs_to :answerable, polymorphic: true
end
