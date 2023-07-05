module DateHelper
	# "MM/DD"
	def date_as_month_day(date)
		date.strftime("%B %d")
	end

	# "MM/DD/YYYY"
	def date_as_month_day_year(date)
		date.present? ? date.strftime("%B %d, %Y") : 'Tentative'
	end

	def remaining_days(date)
		(date - Date.today).to_i
	end

	def months_to_years_months(months)
		years, remaining_months = months.divmod(12)

		result = if remaining_months.zero?
		"#{years} #{'year'.pluralize(years)}"
		else
		"#{years} #{'year'.pluralize(years)}, #{remaining_months} #{'month'.pluralize(remaining_months)}"
		end

		result
	end
end