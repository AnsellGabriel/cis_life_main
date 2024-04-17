class Reports::BooksPdfJob
  include Sidekiq::Job
  include Reports::Concerns::Downloadable


  def perform(employee_id, date_from, date_to, type)
    employee = Employee.find(employee_id)
    save_path = Rails.root.join("public/uploads/employee/report/#{employee_id}", "#{type}.pdf")

    delete_file_and_create_path(employee, save_path)
    set_dates(date_from, date_to)

    case type
    when "general_disbursement_book"
      entries = Accounting::Check.where(post_date: @search_date, status: :posted)
    when "journal_book"
      entries = Accounting::Journal.where(post_date: @search_date, status: :posted)
    when "receipt_book"
      entries = Treasury::CashierEntry.where(or_date: @search_date, status: :posted)
    end

    begin
      # Render template as PDF
      pdf_contents = ApplicationController.render(
        pdf: "#{type}.pdf",
        template: "accounting/shared/show",
        assigns: {
          date_from: date_from.to_date,
          date_to: date_to.to_date,
          entries: entries,
          title: type.humanize.upcase
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
end
