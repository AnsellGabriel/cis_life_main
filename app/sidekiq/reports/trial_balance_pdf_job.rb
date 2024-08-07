class Reports::TrialBalancePdfJob
  include Sidekiq::Job

  def perform(employee_id, date_from, date_to)
    employee = Employee.find(employee_id)
    save_path = Rails.root.join("public/uploads/employee/report/#{employee_id}", "trial_balance.pdf")
    employee.delete_uploaded_report
    FileUtils.mkdir_p(File.dirname(save_path))
    date_range = date_from&.to_date..date_to&.to_date
    initialize_variables

    begin
      # Render template as PDF
      pdf_contents = ApplicationController.render(
        pdf: "trial_balance.pdf",
        template: "reports/accounts/download_trial_balance",
        assigns: {
          date_from: date_from&.to_date.beginning_of_day,
          date_to: date_to&.to_date.end_of_day,
          assets: @assets,
          liabilities: @liabilities,
          income: @income,
          expense: @expense,
          reserve: @reserve,
          total_debit: 0,
          total_credit: 0,
          ytd_total_debit: 0,
          ytd_total_credit: 0
        }
      )

      File.open(save_path, 'wb') { |file|
        file << pdf_contents
        employee.update!(report: file)
      }

      sleep 2 # wait for the file to be saved before broadcasting
      broadcast_download(employee)
    rescue => e
      # Handle errors (e.g., log the error, send a notification, etc.)
      Rails.logger.error("Save path: #{save_path}, Error generating PDF: #{e.message}")
    end
  end

  private

  def initialize_variables
    @assets = Treasury::Account.where(account_type: 1)
    @liabilities = Treasury::Account.where(account_type: 2)
    @income = Treasury::Account.where(account_type: 4)
    @expense = Treasury::Account.where(account_type: 5)
    @reserve = Treasury::Account.where(account_type: 6)
  end

  def broadcast_download(employee)
    Turbo::StreamsChannel.broadcast_replace_to ["downloader", employee.user.to_gid_param].join(":"),
      target: "download_cont_#{employee.user.id}",
      partial: "layouts/partials/download_script",
      locals: { title: employee.report.identifier, link_path: employee.report.url}
  end
end
