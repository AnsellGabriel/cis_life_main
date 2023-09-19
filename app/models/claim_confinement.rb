class ClaimConfinement < ApplicationRecord
  belongs_to :process_claim, optional: true

  def days_confinement
    (date_discharge - date_admit).to_i
  end

  def amount_confinement
      
      amount * days_confinement
  end
end
