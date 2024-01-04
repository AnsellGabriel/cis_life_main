class CreateActuarialReserves < ActiveRecord::Migration[7.0]
  def change
    create_table :actuarial_reserves do |t|
      t.date :first_term
      t.date :second_term
      t.date :third_term
      t.decimal :total_unearned_prem, precision: 10, scale: 2
      t.decimal :total_first_advance_prem, precision: 10, scale: 2
      t.decimal :total_second_advance_prem, precision: 10, scale: 2
      t.decimal :total_reserve, precision: 10, scale: 2
      t.decimal :total_unearned_pr, precision: 10, scale: 2
      t.decimal :total_first_advance_pr, precision: 10, scale: 2
      t.decimal :total_second_advance_pr, precision: 10, scale: 2
      t.decimal :total_reserve_ret, precision: 10, scale: 2
      t.belongs_to :plan#, null: false, foreign_key: true

      t.timestamps
    end
  end
end
