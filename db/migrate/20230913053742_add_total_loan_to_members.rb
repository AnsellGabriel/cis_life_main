class AddTotalLoanToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :total_loan_amount, :decimal, precision: 15, scale: 2, default: 0.0
    add_column :members, :for_reinsurance, :boolean, default: false
  end
end
