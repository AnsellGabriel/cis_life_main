class AddTypeToAgreements < ActiveRecord::Migration[7.0]
  def change
    add_column :agreements, :agreement_type, :string
  end
end
