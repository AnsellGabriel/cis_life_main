class AddCoopToClaimRemark < ActiveRecord::Migration[7.0]
  def change
    add_column :claim_remarks, :coop, :boolean
  end
end
