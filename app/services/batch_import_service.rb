class BatchImportService
  def initialize(spreadsheet, group_remit, cooperative)
    @spreadsheet = spreadsheet
    @group_remit = group_remit
    @cooperative = cooperative  
    @agreement = @group_remit.agreement
    @gyrt_plans = ['GYRT', 'GYRTF']
    @gyrt_ranking_plans = ['GYRTBR', 'GYRTFR']
    @principal_headers = ["First Name", "Middle Name", "Last Name", "Suffix", "Transferred?"]
    @principal_headers << "Rank" if @gyrt_ranking_plans.include?(@agreement.plan.acronym)
  end

  def import_batches
    headers = extract_headers(@spreadsheet, 'Principal')
    principal_spreadsheet = parse_file('Principal')
    missing_headers = find_missing_headers(@principal_headers, headers)
    min_participation = @agreement.proposal.minimum_participation
    initialize_counters_and_arrays
    agreement_benefits = @agreement.agreement_benefits

    if missing_headers.any?
      return "The following CSV headers are missing: #{missing_headers.join(', ')}"
    end

    if principal_spreadsheet.size < min_participation
      return "Imported members must be at least #{min_participation}. Current count: #{principal_spreadsheet.size}"
    end

    principal_spreadsheet.each do |row|
      batch_hash = extract_batch_data(row)
      member = find_or_initialize_member(batch_hash)

      if @gyrt_ranking_plans.include?(@agreement.plan.acronym)
        unless row[0].present?
          create_denied_member(member, 'Rank not present')
          next
        end
      end

      age_min_max = age_min_max_by_insured_type(agreement_benefits, batch_hash[:rank])
      
      if age_not_within_range?(member, age_min_max)
        create_denied_member(member, 'Age not within agreement\'s age range')
        next
      end

      unless member.persisted?
        create_denied_member(member, 'Unenrolled member.')
        next
      end

      duplicate_member = find_duplicate_member(member)

      if duplicate_member
        # add_duplicate_member(member)
        create_denied_member(member, 'Member already exist in the group remit.')
        next
      else
        @added_members_counter += create_batch(member, batch_hash)
      end
    end

    import_result = {
      added_members_counter: @added_members_counter,
      denied_members_counter: @denied_members_counter,
    }
  end
  
  private

  def find_missing_headers(required_headers, headers)
    required_headers - headers
  end

  def extract_headers(spreadsheet, sheet_name)
    spreadsheet.sheet(sheet_name).row(1).map(&:strip)
  end

  def parse_file(sheet_name)
    @spreadsheet.sheet(sheet_name).parse.delete_if { |row| row.all?(&:blank?) }
  end

  def create_denied_member(member, reason)
    DeniedMember.find_or_create_by!(
      name: "#{member.first_name} #{member.middle_name} #{member.last_name}", 
      age: member.age, 
      reason: reason, 
      group_remit: @group_remit
    )
    increment_denied_members_counter
  end

  def age_min_max_by_insured_type(agreement_benefits, rank)
    
    if @gyrt_plans.include?(@agreement.plan.acronym)
      {
        min_age: agreement_benefits.find_by(insured_type: :principal).min_age,
        max_age: agreement_benefits.find_by(insured_type: :principal).max_age
      }
    elsif @gyrt_ranking_plans.include?(@agreement.plan.acronym)
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
  end

  def extract_batch_data(row)
    {
      first_name: row[2].to_s.upcase,
      middle_name: row[3].to_s.upcase,
      last_name: row[1].to_s.upcase,
      suffix: row[4].to_s.upcase,
      rank: row[5].to_s.present? ? row[5].to_s.upcase : nil,
      transferred: row[0].to_s.upcase == "TRUE"
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
