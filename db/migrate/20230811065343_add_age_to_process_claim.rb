class AddAgeToProcessClaim < ActiveRecord::Migration[7.0]
  def change
    add_column :process_claims, :age, :integer
  end
end
