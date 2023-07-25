class AddReferencesToLoanInsuranceDetails < ActiveRecord::Migration[7.0]
  def change
    add_reference :loan_insurance_details, :loan_insurance_loan, null: false, foreign_key: true
    add_reference :loan_insurance_details, :loan_insurance_rate, null: false, foreign_key: true
    add_reference :loan_insurance_details, :loan_insurance_retention, null: false, foreign_key: true
  end
end
