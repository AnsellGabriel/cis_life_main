class Reports::AccountLedgerPdfJob
  include Sidekiq::Job
  include Reports::Concerns::Downloadable

  def perform(employee_id, account_id, date_from, date_to)
    employee = Employee.find(employee_id)
    @account = Treasury::Account.find(account_id)
    save_path = Rails.root.join("public/uploads/employee/report/#{employee_id}", "#{@account.name.downcase}_ledger.pdf")

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
      # Render template as PDF
      pdf_contents = ApplicationController.render(
        pdf: "#{@account.name.downcase}_ledger.pdf",
        template: "treasury/accounts/show_pdf",
        assigns: {
          date_from: date_from.to_date,
          date_to: date_to.to_date,
          account: @account,
          searched_ledgers: @searched_ledgers,
          initial_balance: @balance,
          total_debit: @total_debit,
          total_credit: @total_credit
        }
      )

      # This saves the PDF to disk, but could put in the DB,
      # upload with ActiveStorage, attach to email, etc...
      File.open(save_path, 'wb') { |file|
        file << pdf_contents
        employee.update!(report: file)
      }

      sleep 2 # wait for the file to be saved before broadcasting
      broadcast_download(employee)
    rescue => e
      # Handle errors (e.g., log the error, send a notification, etc.)
      Rails.logger.error("Error generating PDF: #{e.message}")
    end
  end

  def set_balance(date_from)
    @balance = @account.general_ledgers.where(transaction_date: DateTime.new(Date.today.year, 1, 1)..date_from&.to_date&.prev_day).sum(:amount)
    @total_debit = @searched_ledgers.debits.sum(:amount)
    @total_credit = @searched_ledgers.credits.sum(:amount)
  end
end
