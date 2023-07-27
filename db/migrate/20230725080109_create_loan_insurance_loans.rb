class CreateLoanInsuranceLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_insurance_loans do |t|
      t.string :name
      t.string :description
      t.references :cooperative, null: false, foreign_key: true

      t.timestamps
    end
  end
end
