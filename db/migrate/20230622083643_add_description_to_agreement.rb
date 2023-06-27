class AddDescriptionToAgreement < ActiveRecord::Migration[7.0]
  def change
    add_column :agreements, :description, :string
  end
end
