class AddCooperativeToAgreements < ActiveRecord::Migration[7.0]
  def change
    add_reference :agreements, :cooperative, null: false, foreign_key: true
  end
end
