# cooperatives
puts "Creating cooperatives..."
spreadsheet = Roo::Spreadsheet.open("./db/uploads/Operating Coops.xlsx")
(5..spreadsheet.last_row).each do |i|
  begin
    coop = Cooperative.new
    coop.name = spreadsheet.cell(i,'B').to_s.strip
    coop.registration_number = spreadsheet.cell(i,'A').to_s.strip
    coop.cooperative_type = spreadsheet.cell(i,'H').to_s.strip
    coop.email = spreadsheet.cell(i,'K').to_s.strip
    coop.contact_number = spreadsheet.cell(i,'J').to_s.strip
    coop.street = spreadsheet.cell(i,'F').to_s.strip
    coop.geo_region_id = case spreadsheet.cell(i,'C').upcase
      when "NCR" then 14
      when "CAR" then 15
      when "CARAGA" then 17
      when "REGION 01" then 1
      when "REGION 02" then 2
      when "REGION 03" then 3
      when "REGION 04-A" then 4
      when "REGION 04-B" then 5
      when "REGION 05" then 6
      when "REGION 06" then 7
      when "REGION 07" then 8
      when "REGION 08" then 9
      when "REGION 09" then 10
      when "REGION 10" then 11
      when "REGION 11" then 12
      when "REGION 12" then 13
    end
    coop.geo_province = coop.geo_region.geo_provinces.find_by(name: spreadsheet.cell(i,'D').to_s.strip)
    coop.geo_municipality = coop.geo_province.geo_municipalities.find_by(name: spreadsheet.cell(i,'E').to_s.strip)

    main_branch = coop.coop_branches.find_or_initialize_by(name: 'Main')
    main_branch.street = coop.street
    main_branch.geo_municipality = coop.geo_municipality
    main_branch.geo_province = coop.geo_province
    main_branch.geo_region = coop.geo_region
    main_branch.save!
    coop.save!

    puts "#{coop.name} added"
  rescue => e
    puts "Error: #{e.message}"
  end
end
