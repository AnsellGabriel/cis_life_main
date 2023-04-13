# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

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

10.times do |i|
    CoopBranch.create!(name: "Branch #{i}", cooperative_id: 1, region: "Region 1", province: "Province 1", municipality: "Municipality 1", barangay: "Barangay 1", street: "Street 1", contact_details: "09123456789")
end

coop_member_spreadsheet = Roo::Spreadsheet.open("/Users/macbookair/Downloads/gyrt_member.xlsx")

(2..coop_member_spreadsheet.last_row).each do |row|
    spreadsheet = coop_member_spreadsheet
    CoopMember.find_or_create_by!(
        last_name: spreadsheet.cell(row, 'A'), 
        first_name: spreadsheet.cell(row, 'B'), 
        middle_name: spreadsheet.cell(row, 'C'), 
        birthdate: spreadsheet.cell(row, 'D'), 
        coop_branch_id: 1, 
        mobile_number: '09678593657', 
        email: 'test@gmail.com', 
        cooperative_id: 1,
        gender: 'male',
        civil_status: 'single',
        address: 'Blk 1 Lot 1, phase2, Brgy. 1, Municipality 1, Province 1, Region 1',
        occupation: 'Programmer',
        employer: '!cisp',
        work_address: '1CISP bldg, Mapagbigay st, Diliman, Quezon City',
        work_phone_number: '09129485746',
        suffix: '',
        birth_place: 'Quezon City',
        sss_no: 1827463748,
        tin_no: 2948573849,
        legal_spouse: 'Glenda Worker',
        height: 178,
        weight: 60
    )

    
    # puts "#{member.last_name} #{member.first_name} #{member.middle_name}" if member.save
end
