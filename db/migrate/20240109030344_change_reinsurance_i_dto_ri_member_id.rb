class ChangeReinsuranceIDtoRiMemberId < ActiveRecord::Migration[7.0]
  def change
    remove_reference :reinsurance_batches, :reinsurance#, foreign_key: true
    add_reference :reinsurance_batches, :reinsurance_member#, foreign_key: true
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
