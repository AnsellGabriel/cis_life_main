class RenameOrNumberToOfficialReceiptInGroupRemit < ActiveRecord::Migration[7.0]
  def change
    rename_column :group_remits, :or_number, :official_receipt
  end
end
