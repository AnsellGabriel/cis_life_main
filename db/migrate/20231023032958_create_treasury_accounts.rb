class CreateTreasuryAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :treasury_accounts do |t|
      t.string :name
      t.integer :account_type
      t.boolean :is_check_account, default: false
      t.string :contact_number
      t.string :address

      t.timestamps
    end
  end
end
