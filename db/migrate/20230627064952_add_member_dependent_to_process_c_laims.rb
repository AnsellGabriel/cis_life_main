class AddMemberDependentToProcessCLaims < ActiveRecord::Migration[7.0]
  def change
    add_reference :process_claims, :batch_beneficiary
  end
end
