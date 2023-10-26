class Accounting::Journal < Accounting::Voucher
  attr_accessor :voucher_year, :voucher_month, :voucher_series

  validates_presence_of :voucher_year, :voucher_month, :voucher_series

  def formatted_voucher
    string_voucher = voucher.to_s
    "#{string_voucher[0..2]}-#{string_voucher[3..4]}-#{string_voucher[5..7]}"
  end
end
