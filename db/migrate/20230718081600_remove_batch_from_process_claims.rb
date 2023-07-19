class RemoveBatchFromProcessClaims < ActiveRecord::Migration[7.0]
  def change
    remove_reference :process_claims, :batch, null: false, foreign_key: true
  end
end
