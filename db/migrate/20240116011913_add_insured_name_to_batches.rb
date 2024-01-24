class AddInsuredNameToBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :first_name, :string
    add_column :batches, :middle_name, :string
    add_column :batches, :last_name, :string
    add_column :batches, :civil_status, :string
    add_column :batches, :birthdate, :date
  end
end
