class CreateProcessRoutes < ActiveRecord::Migration[7.0]
  def change
    create_table :process_routes do |t|
      t.string :name
      t.string :department
      t.string :description

      t.timestamps
    end
  end
end
