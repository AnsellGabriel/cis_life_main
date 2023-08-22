class AddAgreementToLoanInsuranceRates < ActiveRecord::Migration[7.0]
  def change
    add_reference :loan_insurance_rates, :agreement, null: false, foreign_key: true
  end
end
