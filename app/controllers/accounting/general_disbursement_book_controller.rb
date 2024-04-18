class Accounting::GeneralDisbursementBookController < ApplicationController
  def index
  end

  def pdf
    if params[:date_from].present? && params[:date_to].present?
      check_vouchers = Accounting::Check.where(post_date: params[:date_from].to_date..params[:date_to].to_date, status: :posted)

      if check_vouchers.present?
        Accounting::Check.disbursement_book_pdf(current_user.userable.id, params[:date_from], params[:date_to], "general_disbursement_book")

        redirect_to accounting_general_disbursement_book_index_path, notice: "Report is being generated. Please wait for a moment."
      else
        redirect_to accounting_general_disbursement_book_index_path, alert: "No check vouchers found"
      end
    else
      redirect_to accounting_general_disbursement_book_index_path, alert: "Please select date range"
    end
  end
end
