class MemberImportService
  def initialize(spreadsheet, cooperative, current_user)
    @spreadsheet = spreadsheet
    @cooperative = cooperative
    @current_user = current_user
    @required_headers = ["First Name", "Middle Name", "Last Name", "Birthdate"]
    @progress = @current_user.create_progress_tracker(progress: 0.0)
  end

  def import
    headers = extract_headers(@spreadsheet, "Members_Data")

    if headers.nil?
      return "Incorrect/Missing sheet name: Members_Data"
    end

    members_spreadsheet = parse_file("Members_Data")

    missing_headers = find_missing_headers(@required_headers, headers)

    # ! Attributes with Date type should have a format of: yyyy-mm-dd
    # Initialize variables to keep track of member imports
    created_members_counter = 0
    updated_members_counter = 0
    denied_enrollees_counter = 0
    total_members = members_spreadsheet.drop(1).count
    progress_counter = 0
    # Iterate over each row in the CSV file
    members_spreadsheet.drop(1).each do |row|
      # Extract member data from CSV row
      member_hash = {
        last_name: row["Last Name"] == nil ? nil : row["Last Name"].strip,
        first_name: row["First Name"] == nil ? nil : row["First Name"].strip,
        middle_name: row["Middle Name"] == nil ? nil : row["Middle Name"].strip,
        birth_date: row["Birthdate"],
        # gender: row["Gender"],
        # civil_status: row["Civil Status"]
        # suffix: row["Suffix"] == nil ? nil : row["Suffix"].strip,
        # birth_place: row["Birth Place"],
        # address: row["Address"],
        # geo_region: row["Region"] == nil ? nil : GeoRegion.find_by(name: row["Region"].strip),
        # geo_province: row["Province"] == nil ? nil : GeoProvince.find_by(name: row["Province"].strip),
        # geo_municipality: row["Municipality"] == nil ? nil : GeoMunicipality.find_by(name: row["Municipality"].strip),
        # geo_barangay: row["Barangay"] == nil ? nil : GeoBarangay.find_by(name: row["Barangay"].strip),
        # sss_no: row["SSS #"],
        # tin_no: row["TIN #"],
        # mobile_number: row["Mobile #"],
        # email: row["Email"],
        # height: row["Height (cm)"],
        # weight: row["Weight (kg)"],
        # occupation: row["Occupation"],
        # employer: row["Employer"],
        # work_address: row["Work Address"],
        # legal_spouse: row["Spouse"],
        # work_phone_number: row["Work Phone #"]
      }

      # Extract cooperative member data from CSV row
      begin
        coop_member_hash = {
          cooperative_id: @cooperative.id,
          coop_branch_id: @cooperative.coop_branches.find_by(name: row["Branch"].strip).id,
          membership_date: row["Membership Date"] == nil ? Date.today : row["Membership Date"]
        }
      rescue NoMethodError => e
        create_denied_enrollee(row["First Name"], row["Middle Name"], row["Last Name"], "Coop branch not found: #{row["Branch"]}")
        denied_enrollees_counter += 1
        progress_counter += 1
        update_progress(total_members, progress_counter)
        next
      end


      # Check if a member with the same first name, last name, and birth date already exists
      member = Member.find_or_initialize_by(
        first_name: member_hash[:first_name].squish,
        last_name: member_hash[:last_name].squish,
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

        begin
          new_coop_member = new_member.coop_members.create(coop_member_hash) if new_member.save!
          created_members_counter += 1 if new_coop_member.save!
        rescue ActiveRecord::RecordInvalid => e
          create_denied_enrollee(row["First Name"], row["Middle Name"], row["Last Name"], e.message)
          denied_enrollees_counter += 1
          progress_counter += 1
          update_progress(total_members, progress_counter)
          next
        end

      end

      progress_counter += 1
      update_progress(total_members, progress_counter)
    end

    counters = {
      created_members_counter: created_members_counter,
      updated_members_counter: updated_members_counter,
      denied_enrollees_counter: denied_enrollees_counter
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

  def update_progress(total, processed_members)
    @progress.update(progress: (processed_members.to_f / total.to_f * 100))
  end

  def create_denied_enrollee(first_name, middle_name, last_name, reason)
    denied_enrollee = DeniedEnrollee.create(
      name: "#{first_name} #{middle_name} #{last_name}",
      reason: reason,
      cooperative_id: @cooperative.id
    )
  end
end
