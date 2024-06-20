class UpdateClaimsDatas < ActiveRecord::Migration[7.0]
  def change
    add_column :claim_remarks, :removed, :boolean
    add_column :claim_causes, :postmortem, :text
    add_column :claim_causes, :cause_of_incident, :text
    remove_column :claim_coverages, :coverageable_type, :string
    remove_column :claim_coverages, :coverageable_id, :bigint
    add_reference :claim_coverages, :batch
  end
end
