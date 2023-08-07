class AddEffectivityToAgreementsCoopMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :agreements_coop_members, :effectivity, :date
  end
end
