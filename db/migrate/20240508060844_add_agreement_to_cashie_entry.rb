class AddAgreementToCashieEntry < ActiveRecord::Migration[7.0]
  def change
    add_reference :treasury_cashier_entries, :agreement#, null: false, foreign_key: true
    add_reference :treasury_cashier_entries, :plan#, null: false, foreign_key: true
  end
end
