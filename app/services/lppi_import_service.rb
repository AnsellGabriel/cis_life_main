class LppiImportService
  def initialize(spreadsheet, group_remit, cooperative)
    @spreadsheet = spreadsheet
    @group_remit = group_remit
    @cooperative = cooperative
    @agreement = @group_remit.agreement

    @headers = ["FIRST_NAME", "MIDDLE_NAME", "LAST_NAME", "BIRTHDATE", "EFFECTIVITY_DATE", "EXPIRY_DATE", "RELEASE_DATE", "MATURITY_DATE", "LOAN_AMOUNT", "LOAN_TYPE"]

    @progress_tracker = @group_remit.create_group_import_tracker(progress: 0.0)
  end

  def import
    initialize_counters_and_arrays
    headers = extract_headers(@spreadsheet, 'LPPI')

    if headers.nil?
      return "Incorrect/Missing sheet name: LPPI"
    end

    spreadsheet = parse_file('LPPI')
    missing_headers = check_missing_headers('LPPI', @headers, headers)
    return missing_headers if missing_headers

    total_members = spreadsheet.drop(1).count
    progress_counter = 0

    spreadsheet.drop(1).each do |row|
      batch_hash = extract_batch_data(row)
      member = find_or_initialize_member(batch_hash)

      unless member.persisted?
        create_denied_member(member, 'Unenrolled member.')
        progress_counter += 1
        update_progress(total_members, progress_counter)
        next
      end

      create_batch(member, batch_hash)
      progress_counter += 1
      update_progress(total_members, progress_counter)
    end

    import_result = {
      added_members_counter: @added_members_counter,
      denied_members_counter: @denied_members_counter
    }

  end

  private

  def initialize_counters_and_arrays
    @added_members_counter = 0
    @denied_members_counter = 0
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

  def check_missing_headers(sheet_name, expected_headers, actual_headers)
    missing_headers = expected_headers - actual_headers
    if missing_headers.any?
      return "The following headers are missing in #{sheet_name}: #{missing_headers.join(', ')}"
    end

    nil
  end

  def extract_batch_data(row)
    {
      first_name: row["FIRST_NAME"].to_s.squish.upcase,
      middle_name: row["MIDDLE_NAME"].to_s.squish.upcase,
      last_name: row["LAST_NAME"].to_s.squish.upcase,
      birth_date: row["BIRTHDATE"],
      effectivity_date: row["EFFECTIVITY_DATE"],
      expiry_date: row["EXPIRY_DATE"],
      release_date: row["RELEASE_DATE"],
      maturity_date: row["MATURITY_DATE"],
      loan_amount: row["LOAN_AMOUNT"],
      loan_type: row["LOAN_TYPE"].to_s.squish.upcase
    }
  end

  def find_or_initialize_member(batch_hash)
    @cooperative.members.find_or_initialize_by(
      first_name: batch_hash[:first_name],
      last_name: batch_hash[:last_name],
      middle_name: batch_hash[:middle_name],
      birth_date: batch_hash[:birth_date]
    )
  end

  def create_denied_member(member, reason, effectivity = nil)
    age = member.instance_of?(MemberDependent) ? member.age : member.age(effectivity)

    denied_member = DeniedMember.find_or_create_by!(
      name: "#{member.first_name} #{member.middle_name} #{member.last_name}",
      age: member.birth_date.nil? ? 0 : age,
      group_remit: @group_remit
    )
    denied_member.reason = reason
    denied_member.save!

    increment_denied_members_counter
  end

  def increment_denied_members_counter
    @denied_members_counter += 1
  end

  def increment_added_members_counter
    @added_members_counter += 1
  end

  def update_progress(total, processed_members)
    @progress_tracker.update(progress: (processed_members.to_f / total.to_f) * 100)
  end

  def create_batch(member, batch_hash)
    coop_member = member.coop_members.find_by(cooperative: @cooperative)
    loan_type = LoanInsurance::Loan.find_by(name: batch_hash[:loan_type])

    new_batch = @group_remit.batches.new(
                  coop_member_id: coop_member.id,
                  effectivity_date: batch_hash[:effectivity_date],
                  expiry_date: batch_hash[:expiry_date],
                  date_release: batch_hash[:release_date],
                  date_mature: batch_hash[:maturity_date],
                  loan_amount: batch_hash[:loan_amount],
                  loan: loan_type
                )

    previous_loans = coop_member.active_loans(@group_remit).order(created_at: :desc)

    if previous_loans.any?
      new_batch.unused_loan_id = previous_loans.first.id
    end

    result = new_batch.process_batch

    if loan_type.nil?
      create_denied_member(member, "Loan type #{batch_hash[:loan_type]} not found.")
      increment_denied_members_counter
    elsif result == :no_loan_rate
      create_denied_member(member, "Acceptable age for this plan: #{@agreement.entry_age_from}-#{@agreement.exit_age}. Member's age: #{new_batch.age}")
      increment_denied_members_counter
    else
      new_batch.save!
      increment_added_members_counter
    end
  end
end