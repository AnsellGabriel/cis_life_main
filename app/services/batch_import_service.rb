class BatchImportService
  def initialize(spreadsheet, group_remit, cooperative)
    @spreadsheet = spreadsheet
    @group_remit = group_remit
    @cooperative = cooperative  
    @agreement = @group_remit.agreement
    @gyrt_plans = ['GYRT', 'GYRTF']
    @gyrt_ranking_plans = ['GYRTBR', 'GYRTFR']
    @gyrt_family_plans = ['GYRTF', 'GYRTFR']
    @special_term_insurance = ['PMFC']
    @principal_headers = ["First Name", "Middle Name", "Last Name", "Birthdate", "Transferred?"]
    @principal_headers << "Rank" if @gyrt_ranking_plans.include?(@agreement.plan.acronym)
    @principal_headers << "Terms" if @special_term_insurance.include?(@agreement.plan.acronym)
    @dependent_headers = ["Member First Name", "Member Middle Name", "Member Last Name", "Member Birthdate", "Dependent First Name", "Dependent Middle Name", "Dependent Last Name", "Relationship", "Beneficiary?"]
    @dependent_headers << "Dependent?" if @agreement.plan.gyrt_type == 'family'
  end

  def import_batches
    initialize_counters_and_arrays
    agreement_benefits = @agreement.agreement_benefits
    # min_participation = @agreement.proposal.minimum_participation

    principal_headers = extract_headers(@spreadsheet, 'Principal')
    principal_spreadsheet = parse_file('Principal')
    missing_headers = find_missing_headers(@principal_headers, principal_headers)

    if missing_headers.any?
      return "The following headers are missing: #{missing_headers.join(', ')}"
    end

    # if principal_spreadsheet.size < min_participation
    #   return "Imported members must be at least #{min_participation}. Current count: #{principal_spreadsheet.size}"
    # end

    principal_spreadsheet.drop(1).each do |row|
      batch_hash = extract_batch_data(row)
      member = find_or_initialize_member(batch_hash)

      if @gyrt_ranking_plans.include?(@agreement.plan.acronym)
        unless row["Rank"].present?
          create_denied_member(member, 'Rank not present')
          next
        end
      end

      if @agreement.plan.acronym == 'PMFC'
        unless row["Terms"].present?
          create_denied_member(member, 'Terms not present')
          next
        end
      end

      age_min_max = age_min_max_by_insured_type(agreement_benefits, batch_hash[:rank])
      
      unless member.persisted?
        create_denied_member(member, 'Unenrolled member.')
        next
      end

      if age_not_within_range?(member, age_min_max, @group_remit.effectivity_date)
        create_denied_member(member, 'Age not within agreement\'s age range', @group_remit.effectivity_date)
        next
      end

      duplicate_member = find_duplicate_member(member)

      if duplicate_member
        # add_duplicate_member(member)
        create_denied_member(member, 'Member already exist in the batch.')
        next
      else
        @added_members_counter += create_batch(member, batch_hash)
      end
    end

    ## Dependent batch import section
    dependent_headers = extract_headers(@spreadsheet, 'Member_Dependents')
    dependent_spreadsheet = parse_file('Member_Dependents')
    missing_headers = find_missing_headers(@dependent_headers, dependent_headers)

    if missing_headers.any?
      return "The following headers are missing: #{missing_headers.join(', ')}"
    end

    dependent_spreadsheet.drop(1).each do |row|
      member_name = {
        first_name: row["Member First Name"].to_s.upcase,
        middle_name: row["Member Middle Name"].to_s.upcase,
        last_name: row["Member Last Name"].to_s.upcase,
        birth_date: row["Member Birthdate"]
      }
    
      member = Member.find_by(member_name)

      if member.nil?
        next
      end

      coop_member = @cooperative.coop_members.find_by(member_id: member.id)
      batch = @group_remit.batches.find_by(coop_member_id: coop_member.id)

      dependent_hash = {
        first_name: row["Dependent First Name"].to_s.upcase,
        middle_name: row["Dependent Middle Name"].to_s.upcase,
        last_name: row["Dependent Last Name"].to_s.upcase,
        birth_date: row["Dependent Birthdate"],
        relationship: row["Relationship"].to_s.titleize.strip,
        beneficiary: row["Beneficiary?"],
        dependent: row["Dependent?"]
      }

      dependent = member.member_dependents.find_or_create_by(
        first_name: dependent_hash[:first_name],
        middle_name: dependent_hash[:middle_name],
        last_name: dependent_hash[:last_name],
        birth_date: dependent_hash[:birth_date],
        relationship: dependent_hash[:relationship]
      )

      if dependent_hash[:dependent].to_s.strip.upcase == 'TRUE' && @agreement.plan.gyrt_type == 'family'
        batch_dependent = batch.batch_dependents.find_or_initialize_by(
          member_dependent_id: dependent.id,
        )
        insured_type = batch_dependent.insured_type(dependent[:relationship])
        term_insurance = @agreement.plan.acronym == 'PMFC' ? true : false
        batch_dependent.set_premium_and_service_fees(insured_type, @group_remit, term_insurance)
        batch_dependent.save
      elsif dependent_hash[:beneficiary].to_s.strip.upcase == 'TRUE'
        batch_beneficiary = batch.batch_beneficiaries.find_or_create_by(member_dependent_id: dependent.id)
      end
    end

    import_result = {
      added_members_counter: @added_members_counter,
      denied_members_counter: @denied_members_counter
    }

  end
  
  private

  def find_missing_headers(required_headers, headers)
    required_headers - headers
  end

  def extract_headers(spreadsheet, sheet_name)
    spreadsheet.sheet(sheet_name).row(1).compact.map(&:strip)
  end

  def parse_file(sheet_name)
    @spreadsheet.sheet(sheet_name).parse(headers: true).delete_if { |row| row.all?(&:blank?) }
  end

  def create_denied_member(member, reason, effectivity = nil)
    DeniedMember.find_or_create_by!(
      name: "#{member.first_name} #{member.middle_name} #{member.last_name}", 
      age: member.birth_date.nil? ? 0 : member.age(effectivity), 
      reason: reason, 
      group_remit: @group_remit
    )
    increment_denied_members_counter
  end

  def age_min_max_by_insured_type(agreement_benefits, rank)
    
    if @gyrt_ranking_plans.include?(@agreement.plan.acronym)
      {
        min_age: agreement_benefits.find_by(name: rank).min_age,
        max_age: agreement_benefits.find_by(name: rank).max_age
      }
    else
      {
        min_age: agreement_benefits.find_by(insured_type: :principal).min_age,
        max_age: agreement_benefits.find_by(insured_type: :principal).max_age
      }
    end
  end

  def initialize_counters_and_arrays
    @added_members_counter = 0
    @denied_members_counter = 0
  end

  def extract_batch_data(row)
    {
      first_name: row["First Name"].to_s.strip.upcase,
      middle_name: row["Middle Name"].to_s.strip.upcase,
      last_name: row["Last Name"].to_s.strip.upcase,
      suffix: row["Suffix"].to_s.strip.upcase,
      birth_date: row["Birthdate"],
      rank: row["Rank"].to_s.present? ? row["Rank"].to_s.upcase : nil,
      terms: row["Terms"].to_s.present? ? row["Terms"].to_i : nil,
      transferred: row["Transferred?"].to_s.upcase == "TRUE"
    }
  end
  
  def find_or_initialize_member(batch_hash)
    Member.find_or_initialize_by(
      first_name: batch_hash[:first_name],
      last_name: batch_hash[:last_name],
      middle_name: batch_hash[:middle_name],
      birth_date: batch_hash[:birth_date]
    )
  end

  def age_not_within_range?(member, age_min_max, effectivity_date)
      member.age(effectivity_date) < age_min_max[:min_age] || member.age(effectivity_date) > age_min_max[:max_age]
  end

  def increment_denied_members_counter
    @denied_members_counter += 1
  end

  def find_duplicate_member(member)
    @group_remit.batches.find_by(coop_member_id: member.coop_member_id(@cooperative))
  end

  def create_batch(member, batch_hash)
    coop_member = member.coop_members.find_by(cooperative: @cooperative)
    new_batch = @group_remit.batches.build(coop_member_id: coop_member.id)
    b_rank = @group_remit.agreement.agreement_benefits.find_by(name: batch_hash[:rank])
    # Batch.process_batch(new_batch, @group_remit, batch_hash[:rank], batch_hash[:transferred])
    Batch.process_batch(new_batch, @group_remit, b_rank, batch_hash[:transferred], batch_hash[:terms])
    new_batch.save ? 1 : 0
  end

end
