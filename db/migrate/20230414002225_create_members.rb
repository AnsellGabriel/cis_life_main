class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :suffix
      t.string :email
      t.string :mobile_number
      t.date :birth_date
      t.string :birth_place
      t.string :gender
      t.string :sss_no
      t.string :tin_no
      t.string :address
      t.string :civil_status
      t.string :legal_spouse
      t.float :height
      t.float :weight
      t.string :occupation
      t.string :employer
      t.string :work_address
      t.string :work_phone_number
      t.timestamps
    end
  end
end
