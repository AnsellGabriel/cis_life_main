class AddAnniversaryTypeToAgreements < ActiveRecord::Migration[7.0]
  def change
    add_column :agreements, :anniversary_type, :string
  end
end
