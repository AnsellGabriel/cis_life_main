class ChangeAgreementBenefitIdToNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :process_claims, :agreement_benefit_id, true
  end
end
