class CreateEmpAgreements < ActiveRecord::Migration[7.0]
  def change
    create_table :emp_agreements do |t|
      t.references :employee#, null: false, foreign_key: true
      t.references :agreement#, null: false, foreign_key: true

      t.timestamps
    end
  end
end
