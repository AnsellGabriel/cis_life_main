class AddPlanToAgreements < ActiveRecord::Migration[7.0]
  def change
    add_reference :agreements, :plan, null: false, foreign_key: true
  end
end
