class AddActiveToEmpAgreements < ActiveRecord::Migration[7.0]
  def change
    add_column :emp_agreements, :active, :boolean, default: true
    remove_reference :emp_agreements, :approver
  end
end
