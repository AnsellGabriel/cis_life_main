class Claims::CfLedger < ApplicationRecord
  belongs_to :ledgerable, polymorphic: true
  belongs_to :cf_account
  
  
  enum entry_type: {
    debit: 0,
    credit: 1
  }

  def transact_detail
    if self.ledgerable_type == "Claims::CfAvailment"
      return self.ledgerable.process_claim.claimable.get_fullname
    else
      unless self.ledgerable.description == ""
        return self.ledgerable.description
      else 
        return "Replenishment"
      end
    end
  end
end
