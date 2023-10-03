class AddReadtoClaimRemark < ActiveRecord::Migration[7.0]
  def change
    add_column :claim_remarks, :read, :boolean
    add_column :claim_remarks, :pin, :boolean
  end
end
