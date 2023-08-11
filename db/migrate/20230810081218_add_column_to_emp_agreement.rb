class AddColumnToEmpAgreement < ActiveRecord::Migration[7.0]
  def change
    add_column :emp_agreements, :category_type, :integer
  end
end
