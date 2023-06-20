class AddTypeToPlan < ActiveRecord::Migration[7.0]
  def change
    add_column :plans, :gyrt_type, :string
  end
end
