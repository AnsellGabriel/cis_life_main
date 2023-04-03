json.extract! coop_member_dependent, :id, :last_name, :first_name, :middle_name, :suffix, :birthdate, :coop_member_id, :relationship, :created_at, :updated_at
json.url coop_member_dependent_url(coop_member_dependent, format: :json)
