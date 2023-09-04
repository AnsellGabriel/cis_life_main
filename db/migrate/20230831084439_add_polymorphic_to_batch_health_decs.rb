class AddPolymorphicToBatchHealthDecs < ActiveRecord::Migration[7.0]
  def change
    add_reference :batch_health_decs, :healthdecable, polymorphic: true, null: false
    remove_column :batch_health_decs, :batch_id
  end
end
