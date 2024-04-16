class Reports::AccountLedgerCsvJob
  include Sidekiq::Job
  include ActionView::Helpers::NumberHelper

  def perform(employee_id, account_id, date_from, date_to)
    employee = Employee.find(employee_id)
    @account = Treasury::Account.find(account_id)
    save_path = Rails.root.join("public/uploads/employee/report/#{employee_id}", "#{@account.name.downcase}_#{date_from}_#{date_to}_ledger.csv")

    if File.exist?(save_path)
      broadcast_download(employee)
      return
    else
      employee.delete_uploaded_report
      FileUtils.mkdir_p(File.dirname(save_path))
    end

    set_dates(date_from, date_to)
    set_ledgers
    set_balance(date_from)

    report = CSV.generate(headers: true) do |csv|
      csv << ["Initial Balance", number_to_currency(@balance, unit: "")]
      csv << ["Reference", "Date", "Payee", "Description", "Debit", "Credit", "Balance"]

      @searched_ledgers.each do |record|
        debit = record.debit? ? record.amount : 0
        credit = record.credit? ? record.amount : 0
        @balance += debit - credit

        csv << [record.ledgerable.reference, record.transaction_date.strftime("%B %d, %Y"), record.payee, record.description, number_to_currency(debit, unit: ""), number_to_currency(credit, unit: ""), number_to_currency(@balance, unit: "")]
      end

      csv << ["End Balance", number_to_currency(@balance, unit: "")]
    end

    File.open(save_path, 'wb') { |file|
      file << report
      employee.update!(report: file)
    }

    broadcast_download(employee)

    # csv_file = Tempfile.new(['report', '.csv'])
    # csv_file.write(report)
    # csv_file.close

    # employee.update(report: csv_file)
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
