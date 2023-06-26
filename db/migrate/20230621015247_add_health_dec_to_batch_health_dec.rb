class AddHealthDecToBatchHealthDec < ActiveRecord::Migration[7.0]
  def change
    add_reference :batch_health_decs, :health_dec, null: false, foreign_key: true
  end
end
