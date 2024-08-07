module Treasuries::Path
  extend ActiveSupport::Concern

  included do

    def entry_path
      case params[:e_t]
      when 'ce'
        if @entry.remittance?
          payment_entry_path(@entry.entriable, @entry)
        else
          treasury_cashier_entry_path(@entry)
        end
      when 'cv'
        accounting_check_path(@entry)
      when 'jv'
        accounting_journal_path(@entry)
      when 'da'
        accounting_debit_advice_path(@entry)
      when 'request'
        accounting_voucher_request_path(@entry)
      end
    end
  end

end
