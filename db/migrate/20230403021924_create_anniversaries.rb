class CreateAnniversaries < ActiveRecord::Migration[7.0]
  def change
    create_table :anniversaries do |t|
      t.string :name
      t.date :anniversary_date

      t.timestamps
    end
  end
end
