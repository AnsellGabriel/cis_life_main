class AddTeamsToEmpAgreements < ActiveRecord::Migration[7.0]
  def change
    add_reference :emp_agreements, :team#, null: false, foreign_key: true
  end
end
