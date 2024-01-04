module CurrencyHelper
  def peso_currency(amount)
    number_to_currency(amount, unit: "₱", precision: 2)
  end

  def to_number(amount)
    amount.nil? ? 0.00 : number_with_delimiter(number_with_precision(amount, precision: 2))
  end
end
