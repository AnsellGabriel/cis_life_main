class AddExpiryToAgreementsCoopMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :agreements_coop_members, :expiry, :date
  end
end
