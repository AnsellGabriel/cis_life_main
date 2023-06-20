json.extract! employee, :id, :last_name, :first_name, :middle_name, :birthdate, :employee_number, :mobile_number, :designation, :department_id, :created_at, :updated_at
json.url employee_url(employee, format: :json)
