class DropTableClaimDocument < ActiveRecord::Migration[7.0]
  def change
    drop_table :claim_documents
  end
end
