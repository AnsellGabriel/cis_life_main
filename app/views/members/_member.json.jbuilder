json.extract! member, :id, :last_name, :first_name, :middle_name, :suffix, :email, :mobile_number, :birth_date, :gender, :created_at, :updated_at
json.url member_url(member, format: :json)
