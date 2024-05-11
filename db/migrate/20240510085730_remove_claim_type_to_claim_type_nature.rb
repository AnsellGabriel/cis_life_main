class RemoveClaimTypeToClaimTypeNature < ActiveRecord::Migration[7.0]
  def change
    remove_reference :claim_type_natures, :claim_type
  end
end
