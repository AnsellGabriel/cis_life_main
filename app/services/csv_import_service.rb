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

    import_service = case @type
                      when :member then MemberImportService.new(spreadsheet, @cooperative, @current_user)
                      when :batch then BatchImportService.new(spreadsheet, @group_remit, @cooperative, @current_user)
                      when :lppi then LppiImportService.new(spreadsheet, @group_remit, @cooperative)
                     end

    import_result = import_service.import
    import_result
  end

  private

  attr_reader :file

  def valid_file?
    File.extname(file.path) =~ /csv|xlsx?|xls\z/
  end

  def read_file
    spreadsheet = Roo::Spreadsheet.open(file.path, headers: true)
  end

end
