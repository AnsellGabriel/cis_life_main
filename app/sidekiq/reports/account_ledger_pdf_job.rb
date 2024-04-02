class Reports::AccountLedgerPdfJob
  include Sidekiq::Job

  def perform(employee_id, account_id, date_from, date_to)
    employee = Employee.find(employee_id)
    @treasury_account = Treasury::Account.find(account_id)
    save_path = Rails.root.join("public/uploads/employee/report/#{employee_id}", "#{@treasury_account.name.downcase}_#{date_from}_#{date_to}_ledger.pdf")

    if File.exist?(save_path)
      return
    else
      employee.delete_uploaded_report
      FileUtils.mkdir_p(File.dirname(save_path))
    end

    set_dates(date_from, date_to)
    set_ledgers
    set_balance(date_from)

    begin
      # Render template as PDF
      pdf_contents = ApplicationController.render(
        pdf: "#{@treasury_account.name.downcase}_ledger.pdf",
        template: "treasury/accounts/show_pdf",
        assigns: {
          treasury_account: @treasury_account,
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

      Turbo::StreamsChannel.broadcast_replace_to ["downloader", employee.user.to_gid_param].join(":"),
        target: "download_cont_#{employee.user.id}",
        partial: "layouts/partials/download_script",
        locals: { title: employee.report.identifier, link_path: employee.report.url}
    rescue => e
      # Handle errors (e.g., log the error, send a notification, etc.)
      Rails.logger.error("Error generating PDF: #{e.message}")
    end
  end

  def set_dates(date_from, date_to)
    @search_date = date_from&.to_date..date_to&.to_date
    @balance_date = DateTime.new(Date.today.year, 1, 1)..date_to&.to_date
  end

  def set_ledgers
    @ledgers = @treasury_account.general_ledgers.where(transaction_date: @balance_date)
    @searched_ledgers = @ledgers.where(transaction_date: @search_date)
  end

  def set_balance(date_from)
    @balance = @treasury_account.general_ledgers.where(transaction_date: DateTime.new(Date.today.year, 1, 1)..date_from&.to_date&.prev_day).sum(:amount)
    @total_debit = @searched_ledgers.debits.sum(:amount)
    @total_credit = @searched_ledgers.credits.sum(:amount)
  end
end
