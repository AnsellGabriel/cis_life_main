class AddPlanUnitToSipPb < ActiveRecord::Migration[7.0]
  def change
    add_reference :sip_pbs, :plan_unit, foreign_key: true
  end
end
