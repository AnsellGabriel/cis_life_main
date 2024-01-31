class CreateCheckVoucherRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :check_voucher_requests do |t|
      t.references :requestable, polymorphic: true, null: false
      t.decimal :amount
      t.integer :status
      t.string :analyst
      t.string :description

      t.timestamps
    end
  end
end
