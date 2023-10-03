class AddPayableToPayments < ActiveRecord::Migration[7.0]
  def change
    add_reference :payments, :payable, polymorphic: true, null: false
    remove_column :payments, :group_remit_id
  end
end
