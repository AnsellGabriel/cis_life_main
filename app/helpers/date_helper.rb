module DateHelper
	# "MM/DD"
	def month_day(date)
		date.strftime("%B %d")
	end

	# "MM/DD/YYYY"
	def month_day_year(date)
		date.strftime("%B %d, %Y")
	end
end