# app/services/csv_import_service.rb
class CsvImportService
    def initialize(type, file, cooperative, group_remit=nil)
      @type = type
      @file = file
      @cooperative = cooperative
      @group_remit = group_remit
      
    end
  
    def import
      # byebug 

      if file.nil?
        return "No file uploaded"
      elsif !valid_file?
        return "Only csv, xls, and xlsx file format are accepted"
      end
  
      # headers = extract_headers
      # missing_headers = find_missing_headers(headers)
  
      # if missing_headers.any?
      #   return "The following CSV headers are missing: #{missing_headers.join(', ')}"
      # end
      
      spreadsheet = read_file
      
      case @type
      when :batch
        # if spreadsheet.count < min_participation
        #   return "Imported members must be at least #{min_participation}. Current count: #{csv.count}"
        # end

        import_service = BatchImportService.new(spreadsheet, @group_remit, @cooperative)
        import_result = import_service.import_batches
      when :member
        import_service = MemberImportService.new(spreadsheet, @cooperative)
        import_result = import_service.import_members
      end

      import_result
    end
  
    private
  
    attr_reader :file
  
    # def valid_csv_file?
    #   file.content_type.end_with?("csv")
    # end
  
    # def extract_csv_headers
    #   CSV.open(file.path, &:readline).map(&:strip)
    # end
  
    # def find_missing_headers(headers)
    #   required_headers = @required_headers
    #   required_headers - headers
    # end
  
    # def parse_csv_file
    #   CSV.parse(File.open(file), headers: true, skip_blanks: true).delete_if { |row| row.to_hash.values.all?(&:blank?) }
    # end

    def valid_file?
      File.extname(file.path) =~ /csv|xlsx?|xls\z/
    end

    def extract_headers
      spreadsheet = Roo::Spreadsheet.open(file.path)
      spreadsheet.row(1).map(&:strip)
    end

    def find_missing_headers(headers)
      required_headers = @required_headers
      required_headers - headers
    end

    def read_file
      spreadsheet = Roo::Spreadsheet.open(file.path, headers: true)
      # spreadsheet.parse.delete_if { |row| row.all?(&:blank?) }
    end


  end
  