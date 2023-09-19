class BatchHealthDec < ApplicationRecord
  belongs_to :healthdecable, polymorphic: true
  belongs_to :answerable, polymorphic: true
end
