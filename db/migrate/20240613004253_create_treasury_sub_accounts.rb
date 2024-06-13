class CreateTreasurySubAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :treasury_sub_accounts do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
