class CreateTreasuryBusinessChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :treasury_business_checks do |t|
      t.integer :check_number
      t.date :check_date
      t.decimal :amount, precision: 15, scale: 2
      t.integer :check_type
      t.references :voucher, null: false, foreign_key: { to_table: :accounting_vouchers }

      t.timestamps
    end
  end
end
