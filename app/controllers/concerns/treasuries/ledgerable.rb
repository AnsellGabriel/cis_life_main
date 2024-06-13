module Treasuries::Ledgerable
  extend ActiveSupport::Concern

  included do
    def set_dates
      # date range for ledger search
      if params[:date_from].present? && params[:date_to].present?
        @search_date = params[:date_from]&.to_date..params[:date_to]&.to_date
      end

      # date range for computing ledger current balance
      @balance_date = DateTime.new(Date.today.year, 1, 1)..params[:date_to]&.to_date
    end

    def compute_balance
      # sum of all debits and credits before the first ledger entry
      initial_debit = @ledgers.debits.where("id < ?", @view_ledger.first&.id).sum(:amount)
      initial_credit = @ledgers.credits.where("id < ?", @view_ledger.first&.id).sum(:amount)

      # @prev_day_balance = @treasury_account.general_ledgers.where(transaction_date: DateTime.new(Date.today.year, 1, 1)..params[:date_from]&.to_date&.prev_day).sum(:amount)
      @initial_balance = initial_debit - initial_credit
      @total_debit = @searched_ledgers.debits.sum(:amount)
      @total_credit = @searched_ledgers.credits.sum(:amount)
    end

    def set_ledger_and_pagy
      @ledgers = @account.general_ledgers.where(transaction_date: @balance_date)
      @searched_ledgers = @ledgers.where(transaction_date: @search_date)
      @pagy, @view_ledger = pagy(@searched_ledgers, items: 20)
    end
  end

end
