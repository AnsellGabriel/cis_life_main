class AddSiiColumnInLoanInsuranceLoan < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_loans, :for_sii, :boolean, default: false
  end
end
