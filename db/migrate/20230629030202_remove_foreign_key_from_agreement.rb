class RemoveForeignKeyFromAgreement < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :agreements, :proposals
  end
end
