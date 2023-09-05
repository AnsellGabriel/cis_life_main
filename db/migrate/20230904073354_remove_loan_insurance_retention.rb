class RemoveLoanInsuranceRetention < ActiveRecord::Migration[7.0]
  def change
    remove_reference :loan_insurance_batches, :loan_insurance_retention, foreign_key: :true
  end
end
