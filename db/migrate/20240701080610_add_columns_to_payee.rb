class AddColumnsToPayee < ActiveRecord::Migration[7.0]
  def change
    add_column :payees, :payee_type, :integer
    add_column :payees, :code, :string
    add_reference :payees, :cooperative, foreign_key: true
  end
end
