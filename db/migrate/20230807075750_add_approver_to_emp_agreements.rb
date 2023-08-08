class AddApproverToEmpAgreements < ActiveRecord::Migration[7.0]
  def change
    add_reference :emp_agreements, :approver, foreign_key: { to_table: :employees }#, null: false, foreign_key: true
  end
end
