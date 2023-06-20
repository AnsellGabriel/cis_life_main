class AddNotarizedAndMoaDateToAgreements < ActiveRecord::Migration[7.0]
  def change
    add_column :agreements, :notarized_date, :date
    add_column :agreements, :moa_signed_date, :date
    add_column :agreements, :contestability_period, :date
    add_column :agreements, :nel, :string
  end
end
