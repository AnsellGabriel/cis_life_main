class AddAgeAndInsuranceStatusToBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :age, :integer
    add_column :batches, :insurance_status, :string
  end
end
