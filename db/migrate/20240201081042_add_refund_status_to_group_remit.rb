class AddRefundStatusToGroupRemit < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :refund_status, :integer, default: 0
  end
end
