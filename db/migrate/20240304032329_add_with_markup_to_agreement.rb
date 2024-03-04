class AddWithMarkupToAgreement < ActiveRecord::Migration[7.0]
  def change
    add_column :agreements, :with_markup, :boolean, default: false
  end
end
