class Accounting::JournalEntry < ApplicationRecord
  belongs_to :journable, polymorphic: true
  belongs_to :journal, class_name: "Accounting::Journal", foreign_key: "journal_id"
end
