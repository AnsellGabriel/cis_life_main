class Accounting::JournalBookController < ApplicationController
  def index
  end

  def pdf
    if params[:date_from].present? && params[:date_to].present?
      journal_vouchers = Accounting::Journal.where(post_date: params[:date_from].to_date..params[:date_to].to_date, status: :posted)

      if journal_vouchers.present?
        Accounting::Journal.journal_book_pdf(current_user.userable.id, params[:date_from], params[:date_to], "journal_book")

        redirect_to accounting_journal_book_index_path, notice: "Report is being generated. Please wait for a moment."
      else
        redirect_to accounting_journal_book_index_path, alert: "No journal vouchers found"
      end
    else
      redirect_to accounting_journal_book_index_path, alert: "Please select date range"
    end
  end
end
