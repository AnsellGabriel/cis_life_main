class AddOldCovCodeToLppiBatch < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_batches, :old_cov_code, :string
    add_column :loan_insurance_batches, :old_mem_code, :string
  end
end
