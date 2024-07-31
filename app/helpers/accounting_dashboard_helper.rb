module AccountingDashboardHelper
  include Rails.application.routes.url_helpers

  def accounting_dashboard_link(voucher_type, status=nil)
    link_params = {
      e: current_user.userable.id,
      date_from: params[:date_from],
      date_to: params[:date_to],
      status: status
    }

    case voucher_type
      when :check
        accounting_checks_path(link_params)
      when :journal
        accounting_journals_path(link_params)
      when :debit_advice
        accounting_debit_advices_path(link_params)
    end
  end
end
