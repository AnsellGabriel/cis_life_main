class BatchImportService
  def initialize(csv, group_remit, cooperative)
    @csv = csv
    @group_remit = group_remit
    @cooperative = cooperative
  end

  def import_batches
    initialize_counters_and_arrays

    @csv.each do |row|
      batch_hash = extract_batch_data(row)
      member = find_or_initialize_member(batch_hash)

      if age_not_within_range?(member)
        increment_denied_members_counter
        next
      end

      unless member.persisted?
        add_unenrolled_member(member)
        next
      end

      duplicate_member = find_duplicate_member(member)

      if duplicate_member
        add_duplicate_member(batch_hash)
      else
        @added_members_counter += create_batch(member, batch_hash)
      end
    end

    import_message = "#{@added_members_counter} member(s) added, #{@duplicate_members_counter} duplicate members, #{@denied_members_counter} member(s) denied. #{@unenrolled_members_counter} unenrolled members"
  end
  
  private

  def initialize_counters_and_arrays
    @added_members_counter = 0
    @denied_members_counter = 0
    @duplicate_members_counter = 0
    @unenrolled_members_counter = 0
    @unenrolled_members_array = []
    @denied_members_array = []
    @duplicate_members_array = []
  end

  def extract_batch_data(row)
    {
      first_name: row["First Name"].upcase,
      middle_name: row["Middle Name"].upcase,
      last_name: row["Last Name"].upcase,
      suffix: row["Suffix"].upcase,
      rank: row["Rank"].present? ? row["Rank"].upcase : nil,
      transferred: row["Transferred?"].upcase == "TRUE" ? true : false
    }
  end

  def find_or_initialize_member(batch_hash)
    Member.find_or_initialize_by(
      first_name: batch_hash[:first_name],
      last_name: batch_hash[:last_name],
      middle_name: batch_hash[:middle_name]
    )
  end

  def age_not_within_range?(member)
    member.age < 18 || member.age > 65
  end

  def increment_denied_members_counter
    @denied_members_counter += 1
  end

  def add_unenrolled_member(member)
    @unenrolled_members_array << member
    @unenrolled_members_counter += 1
  end

  def find_duplicate_member(member)
    @group_remit.batches.find_by(coop_member_id: member.coop_member_id(@cooperative))
  end

  def add_duplicate_member(batch_hash)
    @duplicate_members_array << batch_hash
    @duplicate_members_counter += 1
  end

  def create_batch(member, batch_hash)
    coop_member = member.coop_members.find_by(cooperative: @cooperative)
    new_batch = @group_remit.batches.build(coop_member_id: coop_member.id)
    
    Batch.process_batch(new_batch, member, @group_remit, batch_hash[:rank], batch_hash[:transferred])

    # process_dependents(row["Beneficiary"], new_batch, true) if row["Beneficiary"].present?
    # process_dependents(row["Dependents"], new_batch, false) if row["Dependents"].present?

    new_batch.save ? 1 : 0
  end

  def process_dependents(dependents_string, batch, beneficiary)
    dependents = dependents_string.split(",")
    dependents.each do |dependent|
      name, relation = dependent.split(" - ").map(&:strip)
      first_name, last_name = name.split(" ").map(&:strip)
      member_dependent = MemberDependent.find_by(first_name: first_name, last_name: last_name)

      if member_dependent.persisted?
        batch_dependent = batch.batch_dependents.build
        batch_dependent.member_dependent_id = member_dependent.id
        batch_dependent.beneficiary = beneficiary
        batch_dependent.premium = ((premium / 12) * terms)
        batch_dependent.save
      end
    end
  end
end
