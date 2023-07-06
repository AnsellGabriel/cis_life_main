class MemberImportService
    def initialize(spreadsheet, cooperative)
      @spreadsheet = spreadsheet
      @cooperative = cooperative
      @required_headers = ["Birth Place", "First Name", "Middle Name", "Last Name", "Suffix", "Birthdate", "Gender", "Address", "SSS #", "TIN #", "Mobile #", "Email", "Civil Status", "Height (cm)", "Weight (kg)", "Occupation", "Employer", "Work Address", "Spouse", "Work Phone #"]

    end


    def import_members
    headers = extract_headers(@spreadsheet, 'Members_Data')

    if headers.nil?
      return "Incorrect/Missing sheet name: Members_Data"
    end

    members_spreadsheet = parse_file('Members_Data')

    missing_headers = find_missing_headers(@required_headers, headers)


    # ! Attributes with Date type should have a format of: yyyy-mm-dd
    # Initialize variables to keep track of member imports
    created_members_counter = 0
    updated_members_counter = 0

    # Iterate over each row in the CSV file
    members_spreadsheet.drop(1).each do |row|
      # Extract member data from CSV row
      member_hash = {
        last_name: row["Last Name"].strip.upcase,
        first_name: row["First Name"].strip.upcase,
        middle_name: row["Middle Name"].strip.upcase,
        suffix: row["Suffix"].strip.upcase,
        birth_place: row["Birth Place"],
        birth_date: row["Birthdate"],
        gender: row["Gender"],
        address: row["Address"],
        sss_no: row["SSS #"],
        tin_no: row["TIN #"],
        mobile_number: row["Mobile #"],
        email: row["Email"],
        civil_status: row["Civil Status"],
        height: row["Height (cm)"],
        weight: row["Weight (kg)"],
        occupation: row["Occupation"],
        employer: row["Employer"],
        work_address: row["Work Address"],
        legal_spouse: row["Spouse"],
        work_phone_number: row["Work Phone #"]
      }
      # byebug
      # Extract cooperative member data from CSV row
      coop_member_hash = {
        cooperative_id: @cooperative.id,
        coop_branch_id: CoopBranch.find_by(name: row["Branch"].downcase).id,
        membership_date: row["Membership Date"]
      } 

      # Check if a member with the same first name, last name, and birth date already exists
      member = Member.find_or_initialize_by(
        first_name: member_hash[:first_name],
        last_name: member_hash[:last_name],
        birth_date: member_hash[:birth_date]
      )
            
      if member.persisted?
        # check if member is already a coop member
        coop_member = member.coop_members.find_or_initialize_by(cooperative_id: @cooperative.id) 
        member.update(member_hash)
        coop_member.update(coop_member_hash)
        updated_members_counter += 1
      else
        # If a member does not exist, create a new record
        new_member = Member.create(member_hash)
        new_coop_member = new_member.coop_members.create(coop_member_hash) if new_member.save!

        created_members_counter += 1 if new_coop_member.save!
      end
    end
    counters = {
        created_members_counter: created_members_counter,
        updated_members_counter: updated_members_counter
      }
    end

    private

    def extract_headers(spreadsheet, sheet_name)
      begin
        spreadsheet.sheet(sheet_name).row(1).map(&:strip)
      rescue RangeError
        return nil
      end
    end

    def parse_file(sheet_name)
      @spreadsheet.sheet(sheet_name).parse(headers: true).delete_if { |row| row.all?(&:blank?) }
    end

    def find_missing_headers(required_headers, headers)
      required_headers - headers
    end
    
end