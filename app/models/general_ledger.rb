class GeneralLedger < ApplicationRecord
  belongs_to :ledgerable, polymorphic: true
  
end
