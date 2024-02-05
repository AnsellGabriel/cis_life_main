class CreateAgreementProposals < ActiveRecord::Migration[7.0]
  def change
    create_table :agreement_proposals do |t|
      t.belongs_to :agreement#, null: false, foreign_key: true
      t.belongs_to :group_proposal#, null: false, foreign_key: true

      t.timestamps
    end
  end
end
