class Accounting::Journal < Accounting::Voucher
  attr_accessor :voucher_year, :voucher_month, :voucher_series

  validates_presence_of :voucher_year, :voucher_month, :voucher_series, if: :no_voucher_number

  # has_many :general_ledgers, as: :ledgerable

  def reference
    formatted_voucher
  end

  def formatted_voucher
    string_voucher = voucher.to_s
    "#{string_voucher[0..2]}-#{string_voucher[3..4]}-#{string_voucher[5..7]}"
  end

  def entry_type
    'jv'
  end

  private

  def no_voucher_number
    self.voucher.nil?
  end
end
