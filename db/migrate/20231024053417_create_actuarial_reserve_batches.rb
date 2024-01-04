class CreateActuarialReserveBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :actuarial_reserve_batches do |t|
      t.belongs_to :actuarial_reserve#, null: false, foreign_key: true
      t.belongs_to :batchable, polymorphic: true#, null: false, null: false, foreign_key: true
      t.integer :term
      t.decimal :rate, precision: 5, scale: 2
      t.decimal :coverage_less_ri, precision: 10, scale: 2
      t.decimal :prem_less_ri, precision: 10, scale: 2
      t.integer :duration
      t.integer :first_term
      t.integer :second_term
      t.integer :third_term
      t.decimal :unearned_prem, precision: 10, scale: 2
      t.decimal :first_adv_prem, precision: 10, scale: 2
      t.decimal :second_adv_prem, precision: 10, scale: 2
      t.decimal :reserve_amt, precision: 10, scale: 2
      t.decimal :cov_less_ret, precision: 10, scale: 2
      t.decimal :prem_less_ret, precision: 10, scale: 2
      t.decimal :unearned_pr, precision: 10, scale: 2
      t.decimal :first_adv_pr, precision: 10, scale: 2
      t.decimal :second_adv_pr, precision: 10, scale: 2
      t.decimal :reserve_ret_amt, precision: 10, scale: 2

      t.timestamps
    end
  end
end
