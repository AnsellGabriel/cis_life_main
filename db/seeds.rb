# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
spreadsheet = Roo::Spreadsheet.open("./db/uploads/benefits.xlsx")

(2..spreadsheet.last_row).each do |row|
    benefit = Benefit.find_or_initialize_by(name: spreadsheet.cell(row, 'A'))
    benefit.acronym = spreadsheet.cell(row,'B')
    puts "#{benefit.name}" if benefit.save!
end

# Cooperatives
cooperatives_spreadsheet = Roo::Spreadsheet.open("/Users/macbookair/Desktop/cis_data/Operating-Coops.xlsx")
(5..100).each do |row|
    spreadsheet = cooperatives_spreadsheet
    Cooperative.find_or_create_by!(
        registration_number: spreadsheet.cell(row, 'A'), 
        name: spreadsheet.cell(row, 'B'), 
        region: spreadsheet.cell(row, 'C'), 
        province: spreadsheet.cell(row, 'D'), 
        municipality: spreadsheet.cell(row, 'E'), 
        street: spreadsheet.cell(row, 'F'), 
        cooperative_type: spreadsheet.cell(row, 'H'),
        email: spreadsheet.cell(row, 'K'), 
        contact_number: spreadsheet.cell(row, 'J'),
    )
end

#Coop Branches
10.times do |i|
    CoopBranch.create!(name: "Branch #{i+1}", cooperative_id: 1, region: "Region 1", province: "Province 1", municipality: "Municipality 1", barangay: "Barangay 1", street: "Street 1", contact_details: "09123456789")
end

# Coop User
CoopUser.create!(first_name: 'Lian', last_name: 'Postrano', middle_name: 'Elliot', birthdate: FFaker::Time.date, mobile_number: '09948423385', coop_branch_id: 1, cooperative_id: 1)
User.create!(email: 'coop@gmail.com', password: 'password', password_confirmation: 'password', userable_id: 1, userable_type: 'CoopUser')
