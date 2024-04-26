class Accounting::DebitAdvice < Accounting::Voucher
  belongs_to :check_voucher_request, optional: true

  def entry_type
    'da'
  end

  def self.latest_da_for_current_year_and_month
    current_year_and_month = Time.now.strftime("%Y-%m")
    posted.where("voucher LIKE ?", "#{current_year_and_month}%").order(:voucher).last&.voucher
  end
end
