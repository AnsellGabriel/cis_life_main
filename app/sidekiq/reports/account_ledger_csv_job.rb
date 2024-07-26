class Reports::AccountLedgerCsvJob
  include Sidekiq::Job
  include ActionView::Helpers::NumberHelper
  include Reports::Concerns::Downloadable

  def perform(employee_id, account_id, date_from, date_to, is_sub_account = false)
    employee = Employee.find(employee_id)
    @account = is_sub_account ? Treasury::SubAccount.find(account_id) : Treasury::Account.find(account_id)
    save_path = Rails.root.join("public/uploads/employee/report/#{employee_id}", "#{@account.name.downcase}_ledger.csv")

    # if File.exist?(save_path)
    #   broadcast_download(employee)
    #   return
    # else
    #   employee.delete_uploaded_report
    #   FileUtils.mkdir_p(File.dirname(save_path))
    # end

    delete_file_and_create_path(employee, save_path)
    set_dates(date_from, date_to)
    set_ledgers
    set_balance(date_from)

    begin
      report = CSV.generate(headers: true) do |csv|
        csv << Array.new(5, nil) + ["Initial Balance", number_to_currency(@balance, unit: "")]
        csv << ["Reference", "Date", "Payee", "Description", "Debit", "Credit", "Balance"]

        @searched_ledgers.each do |record|
          debit = record.debit? ? record.amount : 0
          credit = record.credit? ? record.amount : 0
          @balance += debit - credit

          csv << [record.ledgerable&.reference, record.transaction_date.strftime("%B %d, %Y"), record.payee, record.description, number_to_currency(debit, unit: ""), number_to_currency(credit, unit: ""), number_to_currency(@balance, unit: "")]
        end

        csv << Array.new(5, nil) + ["End Balance", number_to_currency(@balance, unit: "")]
      end

      File.open(save_path, 'wb') { |file|
        file << report
        employee.update!(report: file)
      }

      sleep 2 # wait for the file to be saved before broadcasting
      broadcast_download(employee)
    rescue => e
      Rails.logger.error("Error generating CSV: #{e.message}")
    end
  end
end
