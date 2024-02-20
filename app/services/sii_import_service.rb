class SiiImportService
  include ActionView::Helpers::NumberHelper

  def initialize(spreadsheet, group_remit, cooperative, current_user)
    @spreadsheet = spreadsheet
    @group_remit = group_remit
    @cooperative = cooperative
    @agreement = @group_remit.agreement
    @current_user = current_user

    @headers = ["FIRST_NAME", "LAST_NAME", "BIRTHDATE", "EFFECTIVITY_DATE", "SAVINGS_AMOUNT"]

    @progress_tracker = @group_remit.create_progress_tracker(progress: 0.0)
  end

  def import
    initialize_counters_and_arrays
    headers = extract_headers(@spreadsheet, "SII")

    if headers.nil?
      return "Incorrect/Missing sheet name: SII"
    end

    spreadsheet = parse_file("SII")
    missing_headers = check_missing_headers("SII", @headers, headers)
    return missing_headers if missing_headers

    total_members = spreadsheet.drop(1).count
    progress_counter = 0

    spreadsheet.drop(1).each do |row|
      batch_hash = extract_batch_data(row)
      member = find_or_initialize_member(batch_hash)

      unless member.persisted?
        create_denied_member(member, "Unenrolled member.")
        progress_counter += 1
        update_progress(total_members, progress_counter)
        next
      end

      coop_member = @cooperative.coop_members.find_by(member_id: member.id)
      duplicate_member = find_duplicate_member(coop_member.id)

      if duplicate_member
        create_denied_member(duplicate_member, "Member already exists in batch.")
      else
        create_batch(member, batch_hash)
      end

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
  end

  def extract_batch_data(row)
    anniv_date = @agreement.anniversaries.first.anniversary_date
    {
      first_name: row["FIRST_NAME"].to_s.squish.upcase,
      middle_name: row["MIDDLE_NAME"].to_s.squish.upcase,
      last_name: row["LAST_NAME"].to_s.squish.upcase,
      birth_date: row["BIRTHDATE"],
      effectivity_date: row["EFFECTIVITY_DATE"],
      expiry_date: row["EFFECTIVITY_DATE"] <= anniv_date ? anniv_date : anniv_date.next_year,
      savings_amount: row["SAVINGS_AMOUNT"],
      premium: mis_user? && row["PREMIUM"].present? ? row["PREMIUM"].to_f : nil
    }
  end

  def find_or_initialize_member(batch_hash)
    @cooperative.members.find_or_initialize_by(
      first_name: batch_hash[:first_name],
      last_name: batch_hash[:last_name],
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

  def find_duplicate_member(id)
    @group_remit.batches.find_by(coop_member_id: id)
  end

  def mis_user?
    @current_user.userable_type == "Employee" && @current_user.userable.department_id == 15
  end

  def create_batch(member, batch_hash)
    coop_member = member.coop_members.find_by(cooperative: @cooperative)
    loan_type = coop_member.cooperative.loans.find_by(for_sii: true)

    new_batch = @group_remit.batches.new(
      coop_member_id: coop_member.id,
      effectivity_date: batch_hash[:effectivity_date],
      expiry_date: batch_hash[:expiry_date],
      loan_amount: batch_hash[:savings_amount],
      loan: loan_type
    )

    result = new_batch.sii_process_batch
        
    if result == :no_rate_for_age
      create_denied_member(member, "No rate available for members age: #{new_batch.age}")
    elsif result == :no_rate_for_amount
      create_denied_member(member, "Savings amount should be 300K or less. Amount: #{new_batch.loan_amount}")
    elsif new_batch.effectivity_date.nil?
      create_denied_member(member, "Effectivity date is missing.")
    else
      new_batch.save!
      increment_added_members_counter
    end
  end
  
end