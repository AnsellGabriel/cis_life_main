module Accounting::Filterable
  extend ActiveSupport::Concern

  included do
    private
    def filtered_and_paginated_vouchers
      @vouchers = @q.result.order(created_at: :desc)
      filter_checks
      @pagy, @vouchers = pagy(@vouchers, items: 10)
    end

    def filter_checks
      filter_by_date_range if params[:date_from].present? && params[:date_to].present?
      filter_by_status if params[:status].present?
    end

    def filter_by_status
      @vouchers = @vouchers.where(status: params[:status])
    end

    def filter_by_date_range
      @vouchers = @vouchers.where(date_voucher: date_range).order(created_at: :desc)
    end

    def date_range
      params[:date_from].to_date.beginning_of_day..params[:date_to].to_date.end_of_day
    end
  end

end
