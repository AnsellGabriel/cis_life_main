module Treasuries::Path
  extend ActiveSupport::Concern

  included do

    def entry_path
      if @entry.remittance?
        payment_entry_path(@entry.entriable, @entry)
      else
        treasury_cashier_entry_path(@entry)
      end
    end

  end

end
