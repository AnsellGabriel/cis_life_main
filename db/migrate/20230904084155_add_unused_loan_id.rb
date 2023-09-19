class AddUnusedLoanId < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_batches, :unused_loan_id, :integer
  end
end
