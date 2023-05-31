# app/services/csv_import_service.rb
class CsvImportService
    def initialize(type, file, required_headers, cooperative, group_remit=nil)
      @type = type
      @file = file
      @required_headers = required_headers
      @cooperative = cooperative
      @group_remit = group_remit
    end
  
    def import
      if file.nil?
        return "No file uploaded"
      elsif !valid_csv_file?
        return "Only CSV file format please"
      end
  
      headers = extract_csv_headers
      missing_headers = find_missing_headers(headers)
  
      if missing_headers.any?
        return "The following CSV headers are missing: #{missing_headers.join(', ')}"
      end
  
      csv = parse_csv_file

      case @type
      when :batch
        if csv.count < @group_remit.agreement.proposal.minimum_participation
          return "Imported members must be at least 100 for GYRT plan. Current count: #{csv.count}"
        end
        import_service = BatchImportService.new(csv, @group_remit, @cooperative)
        import_message = import_service.import_batches
      when :member
        import_service = MemberImportService.new(csv, @cooperative)
        import_message = import_service.import_members
      end

      import_message
    end
  
    private
  
    attr_reader :file
  
    def valid_csv_file?
      file.content_type.end_with?("csv")
    end
  
    def extract_csv_headers
      CSV.open(file.path, &:readline).map(&:strip)
    end
  
    def find_missing_headers(headers)
      required_headers = @required_headers
      required_headers - headers
    end
  
    def parse_csv_file
      CSV.parse(File.open(file), headers: true, skip_blanks: true).delete_if { |row| row.to_hash.values.all?(&:blank?) }
    end
  end
  