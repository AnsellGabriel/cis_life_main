class BatchImportService
  def initialize(spreadsheet, group_remit)
    @spreadsheet = spreadsheet
    @group_remit = group_remit

    @headers = ["FIRST_NAME", "MIDDLE_NAME", "LAST_NAME", "BIRTHDATE", "EFFECTIVITY_DATE", "EXPIRY_DATE", "RELEASE_DATE", "MATURITY_DATE", "LOAN_AMOUNT", "LOAN_TYPE"]

    @progress_tracker = @group_remit.create_group_import_tracker(progress: 0.0)
  end

  def import_loan_batches
    headers = extract_headers(@spreadsheet, 'LPPI')

    if headers.nil?
      return "Incorrect/Missing sheet name: LPPI"
    end

    spreadsheet = parse_file('LPPI')
    missing_headers = check_missing_headers('LPPI', @headers, headers)
    return missing_headers if missing_headers
  end

  private

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
end