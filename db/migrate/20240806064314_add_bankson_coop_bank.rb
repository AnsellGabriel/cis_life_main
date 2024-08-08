class AddBanksonCoopBank < ActiveRecord::Migration[7.0]
  def change
    add_reference :coop_banks, :bank
    add_reference :claim_distributions, :coop_bank
  end
end
