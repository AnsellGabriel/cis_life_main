module CurrencyHelper
	def peso_currency(amount)
		number_to_currency(amount, unit: '₱', precision: 2)
	end
end