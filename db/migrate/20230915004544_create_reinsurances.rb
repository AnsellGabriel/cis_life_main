class CreateReinsurances < ActiveRecord::Migration[7.0]
  def change
    create_table :reinsurances do |t|
      t.date :date_from
      t.date :date_to
      t.decimal :ri_total_amount
      t.decimal :ri_total_prem

      t.timestamps
    end
  end
end
