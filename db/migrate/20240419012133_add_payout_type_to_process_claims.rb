class AddPayoutTypeToProcessClaims < ActiveRecord::Migration[7.0]
  def change
    add_column :process_claims, :payout_type, :integer
  end
end
