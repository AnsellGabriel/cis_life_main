class AddCoverageIdToClaimsCoverages < ActiveRecord::Migration[7.0]
  def change
    add_reference :claim_coverages, :coverageable, polymorphic: true, null: false
  end
end
