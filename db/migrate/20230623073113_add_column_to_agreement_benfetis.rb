class AddColumnToAgreementBenfetis < ActiveRecord::Migration[7.0]
  def change
    add_column :agreement_benefits, :exit_age, :integer
  end
end
