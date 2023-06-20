json.extract! coop_member, :id, :cooperative_id, :coop_branch_id, :last_name, :first_name, :middle_name, :suffix, :birthdate, :mobile_number, :email, :created_at, :updated_at
json.url coop_member_url(coop_member, format: :json)
