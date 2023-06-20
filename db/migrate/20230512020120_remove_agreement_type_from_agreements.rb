class RemoveAgreementTypeFromAgreements < ActiveRecord::Migration[7.0]
  def change
    remove_column :agreements, :agreement_type
  end
end
