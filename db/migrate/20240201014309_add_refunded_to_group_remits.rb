class AddRefundedToGroupRemits < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :refunded, :boolean, default: false
  end
end
