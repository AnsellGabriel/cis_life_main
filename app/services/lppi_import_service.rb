class LppiImportService
  include ActionView::Helpers::NumberHelper

  def initialize(spreadsheet, group_remit, cooperative, current_user)
    @spreadsheet = spreadsheet
    @group_remit = group_remit
    @cooperative = cooperative
    @agreement = @group_remit.agreement
    @current_user = current_user
    @headers = ["FIRST_NAME", "LAST_NAME", "BIRTHDATE", "EFFECTIVITY_DATE", "EXPIRY_DATE", "LOAN_AMOUNT"]
    @progress_tracker = @group_remit.create_progress_tracker(progress: 0.0)
  end

  def import
    initialize_counters_and_arrays
    headers = extract_headers(@spreadsheet, "LPPI")

    if headers.nil?
      return "Incorrect/Missing sheet name: LPPI"
    end

    spreadsheet = parse_file("LPPI")
    missing_headers = check_missing_headers("LPPI", @headers, headers)
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
      # duplicate_member = find_duplicate_member(coop_member.id)

      # if duplicate_member
      #   # add_duplicate_member(member)
      #   create_denied_member(member, "Member already exist in the batch.")
      # else
      #   create_batch(member, batch_hash)
      # end

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
      loan_type: row["LOAN_TYPE"].to_s.squish.upcase,
      premium: @current_user.is_mis? && row["PREMIUM"].present? ? row["PREMIUM"].to_f : nil,
      unused: @current_user.is_mis? && row["UNUSED"].present? ? row["UNUSED"].to_f : nil,
      unused_eff_date: row["UNUSED_EFF_DATE"].present? ? row["UNUSED_EFF_DATE"] : nil,
      unused_loan_amount: row["UNUSED_LOAN_AMOUNT"].present? ? row["UNUSED_LOAN_AMOUNT"].to_f : nil,
      unused_loan_type: row["UNUSED_LOAN_TYPE"].to_s.squish.upcase,
      reference_id: @current_user.is_mis? && row["REFERENCE_ID"].present? ? row["REFERENCE_ID"].to_s.squish.upcase : nil
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

  def create_denied_member(member, reason, effectivity = nil)
    if member.instance_of?(MemberDependent)
      age = member.age
    else
      age = member.birth_date.nil? ? 0 : member.age
    end

    # age = member.instance_of?(MemberDependent) ? member.age : member.age(effectivity)

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
    active_loans = coop_member.loan_batches.where.not(status: [:terminated, :expired])

    if batch_hash[:reference_id].present?
      unused = active_loans.find_by(reference_id: batch_hash[:reference_id])
    end

    if unused.nil? and (batch_hash[:unused_eff_date].present? or batch_hash[:unused_loan_amount].present? or batch_hash[:unused_loan_type].present?)
      if batch_hash[:unused_loan_type].present?
        unused_loan_type = LoanInsurance::Loan.find_by(name: batch_hash[:unused_loan_type])
        unused = active_loans.find_by(loan_amount: batch_hash[:unused_loan_amount], effectivity_date: batch_hash[:unused_eff_date], loan: unused_loan_type)
      else
        unused = active_loans.find_by(loan_amount: batch_hash[:unused_loan_amount], effectivity_date: batch_hash[:unused_eff_date])
      end

      if unused.nil?
        create_denied_member(member, "No existing loan with the given unused loan type #{unused_loan_type&.name&.upcase}, amount #{number_with_precision(batch_hash[:unused_loan_amount], :precision => 2, :delimiter => ',')} and effectivity date #{batch_hash[:unused_eff_date]&.to_date&.strftime('%b %d, %Y')}. Please check and input manually.")
        return
      end
    end

    new_batch = @group_remit.batches.new(
                  coop_member_id: coop_member.id,
                  effectivity_date: batch_hash[:effectivity_date],
                  expiry_date: batch_hash[:expiry_date],
                  date_release: batch_hash[:release_date],
                  date_mature: batch_hash[:maturity_date],
                  loan_amount: batch_hash[:loan_amount],
                  loan: loan_type,
                  unused_loan_id: (unused.present?) ? unused.id : nil
                )

    result = new_batch.process_batch(batch_hash[:premium], @current_user, batch_hash[:unused])

    if result == :no_rate_for_age
      create_denied_member(member, "No rate available for members with age: #{new_batch.age}")
    elsif result == :no_rate_for_amount
      create_denied_member(member, "No rate available for members age #{new_batch.age} and loan amount #{number_to_currency(batch_hash[:loan_amount], unit: "")}")
    elsif result == :no_dates
      create_denied_member(member, "Missing effectivity date or expiry date.")
    else
      new_batch.save!
      increment_added_members_counter
    end
  end

  # def find_duplicate_member(id)
  #   @group_remit.batches.find_by(coop_member_id: id)
  # end
end
