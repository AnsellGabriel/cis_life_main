class Reports::AccountsController < ApplicationController
  def index
  end

  def trial_balance
    if params[:commit].present?
      current_user.userable.delete_uploaded_report

      if params[:date_from].present? && params[:date_to].present?
        Treasury::Account.trial_balance_pdf(current_user.userable.id, params[:date_from], params[:date_to])

        redirect_to trial_balance_reports_accounts_path, notice: "Generating PDF..."
      else

        redirect_to trial_balance_reports_accounts_path, alert: "Please select date range"
      end
    end
  end
end
