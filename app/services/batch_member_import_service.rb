class BatchMemberImportService
    def initialize(csv, group_remit, cooperative)
      @csv = csv
      @group_remit = group_remit
      @cooperative = cooperative
    end
  
    def import_members
      # Initialize variables to keep track of member imports
      added_members_counter = 0
      denied_members_counter = 0
      duplicate_members_counter = 0
      unenrolled_members_counter = 0
      @unenrolled_members_array = []
      @denied_members_array = []
      @duplicate_members_array = []
    
      # Iterate over each row in the CSV file
      @csv.each do |row|  
        # Extract member data from CSV row
        batch_hash = {
          active: row["Active"],
          first_name: row["First Name"].upcase,
          middle_name: row["Middle Name"].upcase,
          last_name: row["Last Name"].upcase,
          suffix: row["Suffix"].upcase,
          status: row["Status"].downcase
        }
    
        # Find member in the database using their name
        member = Member.find_or_initialize_by(
          first_name: batch_hash[:first_name],
          last_name: batch_hash[:last_name],
          middle_name: batch_hash[:middle_name]
        )
  
        if member.age < 18 or member.age > 65
          @denied_members_array << row
          denied_members_counter += 1
          next
        end
  
        unless member.persisted?
          @unenrolled_members_array << member
          unenrolled_members_counter += 1
          next
        end
    
        # Check if the member has already been added to this remittance batch
        duplicate_member = @group_remit.batches.find_by(coop_member_id: member.coop_member_id(@cooperative))
    
        if duplicate_member
          # Member has already been added to this remittance batch
          @duplicate_members_array << batch_hash
          duplicate_members_counter += 1
        elsif !duplicate_member
          # Member has not yet been added to this remittance batch
          new_batch = @group_remit.batches.build
          # Set batch attributes
          terms = new_batch.group_remit.terms
          new_batch.active = batch_hash[:active]

          new_batch.status = batch_hash[:status] == "new" ? "recent" : batch_hash[:status]
          new_batch.coop_member_id = member.coop_member_id(@cooperative)
          agreement = @group_remit.agreement
          coop_member = new_batch.coop_member
          renewal_member = agreement.coop_members.find_by(id: coop_member.id)
          
          if renewal_member.present?
            new_batch.status = :renewal
          else
            new_batch.status = :recent
            agreement.coop_members << coop_member
          end
  
          if row["Beneficiary"].present?
            # assuming the string is stored in a variable named 'relationship_string'
            dependents = row["Beneficiary"].split(",") # split the string by comma
            formatted_dependents = dependents.map do |dependent|
              name, relation = dependent.split(" - ").map(&:strip) # split each relationship by " - "
              first_name, last_name = name.split(" ").map(&:strip)
              
              member_dependent = MemberDependent.find_by(first_name: first_name, last_name: last_name)
  
              if member_dependent.persisted?
                batch_dependent = new_batch.batch_dependents.build
                batch_dependent.member_dependent_id = member_dependent.id
                batch_dependent.beneficiary = true
                batch_dependent.save
              end
  
            end
          end
  
          if row["Dependents"].present?
            # assuming the string is stored in a variable named 'relationship_string'
            dependents = row["Dependents"].split(",") # split the string by comma
            formatted_dependents = dependents.map do |dependent|
              name, relation = dependent.split(" - ").map(&:strip) # split each relationship by " - "
              first_name, last_name = name.split(" ").map(&:strip)
              
              member_dependent = MemberDependent.find_by(first_name: first_name, last_name: last_name)
  
              if member_dependent.present?
                batch_dependent = new_batch.batch_dependents.build
                batch_dependent.member_dependent_id = member_dependent.id
                batch_dependent.dependent = true
                batch_dependent.premium = ((premium / 12) * terms)
                batch_dependent.save
              end
  
            end
          end
    
          added_members_counter += 1 if new_batch.save
        else
          # Member data is invalid or incomplete
          @denied_members_array << batch_hash
          denied_members_counter += 1
        end
      end
    
      import_message = "#{added_members_counter} member(s) added, #{duplicate_members_counter} duplicate members, #{denied_members_counter} member(s) denied. #{unenrolled_members_counter} unenrolled members"
    end
  end
  