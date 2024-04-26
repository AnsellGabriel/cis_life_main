module Reports::Concerns::Downloadable
  extend ActiveSupport::Concern

  # The code inside the included block is evaluated
  # in the context of the class that includes the Visible concern.
  # You can write class macros here, and
  # any methods become instance methods of the including class.
  included do
    def delete_file_and_create_path(employee, save_path)
      employee.delete_uploaded_report
      FileUtils.mkdir_p(File.dirname(save_path))
    end

    def set_dates(date_from, date_to)
      @search_date = date_from&.to_date..date_to&.to_date
      @balance_date = DateTime.new(Date.today.year, 1, 1)..date_to&.to_date
    end

    def set_ledgers
      @ledgers = @account.general_ledgers.where(transaction_date: @balance_date)
      @searched_ledgers = @ledgers.where(transaction_date: @search_date)
    end

    def set_balance(date_from)
      @balance = @account.general_ledgers.where(transaction_date: DateTime.new(Date.today.year, 1, 1)..date_from&.to_date&.prev_day).sum(:amount)
    end

    def broadcast_download(employee)
      Turbo::StreamsChannel.broadcast_replace_to ["downloader", employee.user.to_gid_param].join(":"),
        target: "download_cont_#{employee.user.id}",
        partial: "layouts/partials/download_script",
        locals: { title: employee.report.identifier, link_path: employee.report.url}
    end
  end

  # The methods added inside the class_methods block (or, ClassMethods module)
  # become the class methods on the including class.
  class_methods do

  end
end
