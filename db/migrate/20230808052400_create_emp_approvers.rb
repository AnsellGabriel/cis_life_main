class CreateEmpApprovers < ActiveRecord::Migration[7.0]
  def change
    create_table :emp_approvers do |t|
      t.references :employee#, null: false, foreign_key: true
      t.references :approver, foreign_key: { to_table: :employees }#, null: false, foreign_key: true

      t.timestamps
    end
  end
end
