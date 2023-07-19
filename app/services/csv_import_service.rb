# app/services/csv_import_service.rb
class CsvImportService
    def initialize(type, file, cooperative, group_remit=nil, current_user=nil)
      @type = type
      @file = file
      @cooperative = cooperative
      @group_remit = group_remit
      @current_user = current_user
    end
  
    def import
      if file.nil?
        return "No file uploaded"
      elsif !valid_file?
        return "Only csv, xls, and xlsx file format are accepted"
      end
  
      spreadsheet = read_file
      
      case @type
      when :batch
        import_service = BatchImportService.new(spreadsheet, @group_remit, @cooperative)
        import_result = import_service.import_batches
      when :member
        import_service = MemberImportService.new(spreadsheet, @cooperative, @current_user)
        import_result = import_service.import_members
      end

      import_result
    end
  
    private
  
    attr_reader :file

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
    end

  end
  