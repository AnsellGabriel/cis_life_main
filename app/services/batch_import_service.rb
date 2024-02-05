class BatchImportService
  def initialize(spreadsheet, group_remit, cooperative, current_user)
    @spreadsheet = spreadsheet
    @group_remit = group_remit
    @cooperative = cooperative
    @agreement = @group_remit.agreement
    @current_user = current_user

    @gyrt_plans = ["GYRT", "GYRTF"]
    @gyrt_ranking_plans = ["GYRTBR", "GYRTFR"]
    @gyrt_family_plans = ["GYRTF", "GYRTFR"]

    @principal_headers = ["First Name", "Last Name", "Birthdate"]
    @dependent_headers = ["Member First Name", "Member Last Name", "Member Birthdate", "Dependent First Name", "Dependent Last Name", "Relationship",
"Beneficiary?"]

    @principal_headers << "Rank" if @gyrt_ranking_plans.include?(@agreement.plan.acronym)
    @dependent_headers << "Dependent?" if @agreement.plan.dependable?

    @progress_tracker = @group_remit.create_progress_tracker(progress: 0.0)
  end

  def import
    initialize_counters_and_arrays
    agreement_benefits = @agreement.agreement_benefits
    # Principal batch import section
    principal_headers = extract_headers(@spreadsheet, "PRINCIPAL")

    if principal_headers.nil?
      return "Incorrect/Missing sheet name: PRINCIPAL"
    end

    principal_spreadsheet = parse_file("PRINCIPAL")
    missing_principal_headers = check_missing_headers("PRINCIPAL", @principal_headers, principal_headers)

    return missing_principal_headers if missing_principal_headers

    # Dependent batch import section
    dependent_headers = extract_headers(@spreadsheet, "DEPENDENT")

    if dependent_headers.nil?
      return "Incorrect/Missing sheet name: DEPENDENT"
    end

    dependent_spreadsheet = parse_file("DEPENDENT")
    missing_dependent_headers = check_missing_headers("DEPENDENT", @dependent_headers, dependent_headers)
    return missing_dependent_headers if missing_dependent_headers

    available_member_list = @cooperative.unselected_coop_members(@agreement.group_remits.joins(:batches).pluck(:coop_member_id))

    total_members = principal_spreadsheet.drop(1).count + dependent_spreadsheet.drop(1).count
    progress_counter = 0

    principal_spreadsheet.drop(1).each do |row|
      batch_hash = extract_batch_data(row)
      member = find_or_initialize_member(batch_hash)

      unless member.persisted?
        create_denied_member(member, "Unenrolled member.")
        progress_counter += 1
        update_progress(total_members, progress_counter)
        next
      end

      coop_member = @cooperative.coop_members.find_by(member_id: member.id)
      # checks if member is already in another group remit/batch remit
      without_coverage_member = available_member_list.find_by(id: coop_member.id)

      if without_coverage_member.nil?
        create_denied_member(member, "Member already exist in other batch or remittance")
        progress_counter += 1
        update_progress(total_members, progress_counter)
        next
      end

      if @gyrt_ranking_plans.include?(@agreement.plan.acronym)
        unless row["Rank"].present?
          progress_counter += 1
          update_progress(total_members, progress_counter)
          create_denied_member(member, "Option not present")
          next
        end
      end

      age_min_max = age_min_max_by_insured_type(agreement_benefits, batch_hash[:rank])

      if age_min_max.nil?
        create_denied_member(member, "'#{batch_hash[:rank]}' - option not found in the agreement")
        progress_counter += 1
        update_progress(total_members, progress_counter)
        next
      end

      duplicate_member = find_duplicate_member(coop_member.id)

      if duplicate_member
        # add_duplicate_member(member)
        create_denied_member(member, "Member already exist in the batch.")
        progress_counter += 1
        update_progress(total_members, progress_counter)
        next
      else
        create_batch(member, batch_hash)
      end

      progress_counter += 1
      update_progress(total_members, progress_counter)
    end

    dependent_spreadsheet.drop(1).each do |row|
      if [row["Member First Name"], row["Member Middle Name"], row["Member Last Name"], row["Member Birthdate"]].any?(&:nil?)
        next
      end

      member_name = {
        first_name: row["Member First Name"].to_s.squish.upcase,
        middle_name: row["Member Middle Name"].to_s.squish.upcase,
        last_name: row["Member Last Name"].to_s.squish.upcase,
        birth_date: row["Member Birthdate"]
      }

      member = find_or_initialize_member(member_name)

      dependent_hash = {
        first_name: row["Dependent First Name"].to_s.upcase,
        middle_name: row["Dependent Middle Name"].to_s.upcase,
        last_name: row["Dependent Last Name"].to_s.upcase,
        birth_date: row["Dependent Birthdate"],
        relationship: row["Relationship"].to_s.upcase.strip,
        beneficiary: row["Beneficiary?"],
        dependent: row["Dependent?"],
        premium: mis_user? && row["Premium"].present? ? row["Premium"].to_f : nil
      }

      unless member.persisted?
        create_denied_member(member, "Dependent denied: #{dependent_hash[:first_name]} #{dependent_hash[:middle_name]} #{dependent_hash[:last_name]} - Principal is not a cooperative member.", nil,
true)
        progress_counter += 1
        update_progress(total_members, progress_counter)
        next
      end

      begin
        dependent = member.member_dependents.find_or_create_by(
          first_name: dependent_hash[:first_name],
          middle_name: dependent_hash[:middle_name],
          last_name: dependent_hash[:last_name],
          birth_date: dependent_hash[:birth_date],
          relationship: dependent_hash[:relationship]
        )
        dependent.save!
      rescue ActiveRecord::RecordInvalid => e
        message = e.message.gsub("Validation failed: ", "")
        create_denied_member(member, "(Denied dependent: #{dependent.to_s}) - #{message}", nil, true)
        progress_counter += 1
        update_progress(total_members, progress_counter)
        next
      end

      unless member.persisted?
        create_denied_member(member, "(Denied dependent: #{dependent.to_s}) - Principal not enrolled in the plan.", nil, true)
        progress_counter += 1
        update_progress(total_members, progress_counter)
        next
      end

      coop_member = @cooperative.coop_members.find_by(member_id: member.id)
      batch = @group_remit.batches.find_by(coop_member_id: coop_member.id)

      if member.nil? || batch.nil?
        create_denied_member(member, "(Denied dependent: #{dependent.to_s}) - Principal not enrolled in the plan.", nil, true)
        progress_counter += 1
        update_progress(total_members, progress_counter)
        next
      end

      if dependent_hash[:dependent].to_s.strip.upcase == "TRUE" && @agreement.plan.dependable? && batch.agreement_benefit.with_dependent?
        batch_dependent = batch.batch_dependents.find_or_initialize_by(
          member_dependent_id: dependent.id,
        )
        insured_type = batch_dependent.insured_type(dependent.relationship)

        dependent_agreement_benefits = agreement_benefits.where("name LIKE ?", "%#{batch.agreement_benefit.name}%").find_by(insured_type: insured_type)

        unless dependent_agreement_benefits.present?
          dependent_agreement_benefits = agreement_benefits.find_by(insured_type: insured_type)
        end

        age_min_max = age_min_max_by_insured_type(agreement_benefits, dependent_agreement_benefits.name)

        if age_min_max.nil?
          create_denied_member(member, "(Denied dependent: #{dependent.to_s}) - '#{dependent_agreement_benefits.name}' option not found in the agreement", nil, true)
          progress_counter += 1
          update_progress(total_members, progress_counter)
          next
        end

        batch_dependent.set_premium_and_service_fees(dependent_agreement_benefits, @group_remit, mis_user? ?dependent_hash[:premium] : nil)

        if batch_dependent.save!
          increment_dependents_counter
        end

        if dependent.age < batch_dependent.agreement_benefit.min_age or dependent.age > batch_dependent.agreement_benefit.max_age

          batch_dependent.insurance_status = :denied

          if dependent.age > batch_dependent.agreement_benefit.max_age
            batch_dependent.batch_remarks.build(remark: "Dependent age is over the maximum age limit of the plan.", status: :denied, user_type: @current_user.userable_type, user_id: @current_user.userable.id)
          else
            batch_dependent.batch_remarks.build(remark: "Dependent age is below the minimum age limit of the plan.", status: :denied, user_type: @current_user.userable_type, user_id: @current_user.userable.id)
          end

          batch_dependent.save!
        end
      end

      if dependent_hash[:beneficiary].to_s.strip.upcase == "TRUE"
        batch_beneficiary = batch.batch_beneficiaries.find_or_create_by(member_dependent_id: dependent.id)
      end

      progress_counter += 1
      update_progress(total_members, progress_counter)

    end

    import_result = {
      added_members_counter: @added_members_counter,
      denied_members_counter: @denied_members_counter,
      added_dependents_counter: @added_dependents_counter,
      denied_dependents_counter: @denied_dependents_counter
    }

  end

  private

  def find_missing_headers(required_headers, headers)
    required_headers - headers
  end

  def extract_headers(spreadsheet, sheet_name)
    begin
      spreadsheet.sheet(sheet_name).row(1).compact.map(&:strip)
    rescue RangeError
      return nil
    end
  end

  def parse_file(sheet_name)
    @spreadsheet.sheet(sheet_name).parse(headers: true).delete_if { |row| row.all?(&:blank?) }
  end

  def create_denied_member(member, reason, effectivity = nil, dependent = nil)
    age = member.instance_of?(MemberDependent)  ? member.age : member.age(effectivity)

    denied_member = DeniedMember.create!(
      name: "#{member.first_name} #{member.middle_name} #{member.last_name}",
      age: member.birth_date.nil? ? 0 : age,
      group_remit: @group_remit
    )
    denied_member.reason = reason
    denied_member.save!

    if dependent
      increment_denied_dependents_counter
    else
      increment_denied_members_counter
    end
  end

  def age_min_max_by_insured_type(agreement_benefits, rank)
    if @gyrt_ranking_plans.include?(@agreement.plan.acronym)
      if agreement_benefits.find_by(name: rank).nil?
        return nil
      end

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
    @added_dependents_counter = 0
    @denied_members_counter = 0
    @denied_dependents_counter = 0
  end

  def extract_batch_data(row)
    {
      first_name: row["First Name"].to_s.squish.upcase,
      middle_name: row["Middle Name"].to_s.squish.upcase,
      last_name: row["Last Name"].to_s.squish.upcase,
      suffix: row["Suffix"].to_s.squish.upcase,
      birth_date: row["Birthdate"],
      rank: row["Rank"].to_s.present? ? row["Rank"].to_s.squish.upcase : nil,
      terms: row["Terms"].to_i.present? ? row["Terms"].to_i : nil,
      premium: row["Premium"].to_f.present? && mis_user? ? row["Premium"].to_f : nil,
    }
  end

  def find_or_initialize_member(batch_hash)
    @cooperative.members.find_or_initialize_by(
      first_name: batch_hash[:first_name],
      last_name: batch_hash[:last_name],
      # middle_name: batch_hash[:middle_name],
      birth_date: batch_hash[:birth_date]
    )
  end

  # def age_not_within_range?(member, age_min_max, effectivity_date)
  #     member.age(effectivity_date) < age_min_max[:min_age] || member.age(effectivity_date) > age_min_max[:max_age]
  # end

  def increment_denied_members_counter
    @denied_members_counter += 1
  end

  def increment_denied_dependents_counter
    @denied_dependents_counter += 1
  end

  def increment_dependents_counter
    @added_dependents_counter += 1
  end

  def find_duplicate_member(id)
    @group_remit.batches.find_by(coop_member_id: id)
  end

  def create_batch(member, batch_hash)
    coop_member = member.coop_members.find_by(cooperative: @cooperative)
    new_batch = Batch.new(coop_member_id: coop_member.id)
    b_rank = @group_remit.agreement.agreement_benefits.find_by(name: batch_hash[:rank])

    Batch.process_batch(
      new_batch,
      @group_remit,
      b_rank,
      mis_user? ? batch_hash[:premium] : nil
    )

    if member.age(@group_remit.effectivity_date) < new_batch.agreement_benefit.min_age or member.age(@group_remit.effectivity_date) > new_batch.agreement_benefit.max_age

      new_batch.insurance_status = :denied

      if member.age(@group_remit.effectivity_date) > new_batch.agreement_benefit.max_age
        new_batch.batch_remarks.build(remark: "Member age is over the maximum age limit of the plan.", status: :denied, user_type: @current_user.userable_type, user_id: @current_user.userable_id)
      else
        new_batch.batch_remarks.build(remark: "Member age is below the minimum age limit of the plan.", status: :denied, user_type: @current_user.userable_type, user_id: @current_user.userable_id)
      end

    end

    @group_remit.batches << new_batch

    new_batch.save!

    new_batch.denied? ? @denied_members_counter += 1 : @added_members_counter += 1
  end

  def update_progress(total, processed_members)
    @progress_tracker.update(progress: (processed_members.to_f / total.to_f) * 100)
  end

  def check_missing_headers(sheet_name, expected_headers, actual_headers)
    missing_headers = expected_headers - actual_headers
    if missing_headers.any?
      return "The following headers are missing in #{sheet_name}: #{missing_headers.join(', ')}"
    end

    nil
  end

  def mis_user?
    @current_user.userable_type == "Employee" && @current_user.userable.department_id == 15
  end
end
