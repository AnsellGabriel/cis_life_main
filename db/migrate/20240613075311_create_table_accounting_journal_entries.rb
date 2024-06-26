class CreateTableAccountingJournalEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :accounting_journal_entries do |t|
      t.references :journable, polymorphic: true, null: false
      t.references :journal, null: false, foreign_key: {to_table: :accounting_vouchers}

      t.timestamps
    end
  end
end
