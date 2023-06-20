class CreateHealthDecs < ActiveRecord::Migration[7.0]
  def change
    create_table :health_decs do |t|
      t.text :question
      t.boolean :active
      t.boolean :with_details
      t.boolean :valid_answer
      t.integer :question_sort

      t.timestamps
    end
  end
end
