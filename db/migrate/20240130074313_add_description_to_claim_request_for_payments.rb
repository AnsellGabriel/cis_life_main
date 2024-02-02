class AddDescriptionToClaimRequestForPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :claim_request_for_payments, :description, :string
  end
end
