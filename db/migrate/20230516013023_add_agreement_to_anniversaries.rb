class AddAgreementToAnniversaries < ActiveRecord::Migration[7.0]
  def change
    add_reference :anniversaries, :agreement, null: false, foreign_key: true
  end
end
