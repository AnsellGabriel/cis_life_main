class AddForMdToLoanInsuranceBatch < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_batches, :for_md, :boolean, default: false
  end
end
