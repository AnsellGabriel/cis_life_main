class BatchImportService
  def initialize(csv, group_remit, cooperative)
    @csv = csv
    @group_remit = group_remit
    @cooperative = cooperative
  end

  def import_batches
    initialize_counters_and_arrays
    agreement_benefits = GroupRemit.includes(agreement: :agreement_benefits).find(@group_remit.id).agreement.agreement_benefits

    @csv.each do |row|
      batch_hash = extract_batch_data(row)
      age_min_max = age_min_max_by_insured_type(agreement_benefits, batch_hash[:rank])
      member = find_or_initialize_member(batch_hash)

      if age_not_within_range?(member, age_min_max)
        increment_denied_members_counter
        @denied_members << [member, 'Age not within agreement range']
        next
      end

      unless member.persisted?
        add_unenrolled_member(member)
        next
      end

      duplicate_member = find_duplicate_member(member)

      if duplicate_member
        # add_duplicate_member(member)
        @denied_members << [member, 'Member already exists']
      else
        @added_members_counter += create_batch(member, batch_hash)
      end
    end

    import_result = {
      added_members_counter: @added_members_counter,
      denied_members_counter: @denied_members_counter,
      denied_members: @denied_members
    }
  end
  
  private

  def age_min_max_by_insured_type(agreement_benefits, rank)
    if rank.nil?
      {
        min_age: agreement_benefits.find_by(insured_type: :principal).min_age,
        max_age: agreement_benefits.find_by(insured_type: :principal).max_age
      }
    else
      case rank
      when 'BOD'
        {
          min_age: agreement_benefits.find_by(insured_type: :ranking_bod).min_age,
          max_age: agreement_benefits.find_by(insured_type: :ranking_bod).max_age
        }      
      when 'SO'
        {
          min_age: agreement_benefits.find_by(insured_type: :ranking_senior_officer).min_age,
          max_age: agreement_benefits.find_by(insured_type: :ranking_senior_officer).max_age
        }
      when 'JO'
        {
          min_age: agreement_benefits.find_by(insured_type: :ranking_junior_officer).min_age,
          max_age: agreement_benefits.find_by(insured_type: :ranking_junior_officer).max_age
        }      
      when 'RF'
        {
          min_age: agreement_benefits.find_by(insured_type: :ranking_rank_and_file).min_age,
          max_age: agreement_benefits.find_by(insured_type: :ranking_rank_and_file).max_age
        }      
      end
    end
  end

  def initialize_counters_and_arrays
    @added_members_counter = 0
    @denied_members_counter = 0
    @denied_members = []
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

  def age_not_within_range?(member, age_min_max)
    member.age < age_min_max[:min_age] || member.age > age_min_max[:max_age]
  end

  def increment_denied_members_counter
    @denied_members_counter += 1
  end

  def add_unenrolled_member(member)
    @denied_members << [member, 'Unerolled']
    increment_denied_members_counter
  end

  def find_duplicate_member(member)
    @group_remit.batches.find_by(coop_member_id: member.coop_member_id(@cooperative))
  end

  # def add_duplicate_member(batch_hash)
  #   @duplicate_members << batch_hash
  #   @duplicate_members_counter += 1
  # end

  def create_batch(member, batch_hash)
    coop_member = member.coop_members.find_by(cooperative: @cooperative)
    new_batch = @group_remit.batches.build(coop_member_id: coop_member.id)
    
    Batch.process_batch(new_batch, @group_remit, batch_hash[:rank], batch_hash[:transferred])

    # process_dependents(row["Beneficiary"], new_batch, true) if row["Beneficiary"].present?
    # process_dependents(row["Dependents"], new_batch, false) if row["Dependents"].present?

    new_batch.save ? 1 : 0
  end

  # def process_dependents(dependents_string, batch, beneficiary)
  #   dependents = dependents_string.split(",")
  #   dependents.each do |dependent|
  #     name, relation = dependent.split(" - ").map(&:strip)
  #     first_name, last_name = name.split(" ").map(&:strip)
  #     member_dependent = MemberDependent.find_by(first_name: first_name, last_name: last_name)

  #     if member_dependent.persisted?
  #       batch_dependent = batch.batch_dependents.build
  #       batch_dependent.member_dependent_id = member_dependent.id
  #       batch_dependent.beneficiary = beneficiary
  #       batch_dependent.premium = ((premium / 12) * terms)
  #       batch_dependent.save
  #     end
  #   end
  # end
end
