class Claims::ClaimCoverage < ApplicationRecord
  belongs_to :process_claim
  belongs_to :batch, optional: true
  # belongs_to :coverageable, polymorphic: true

  Coverage_status = ["Current", "Previous"]
  Status = ["Approved", "Denied", "Pending", "Reconsider"]

  def get_duration
    date_start = effectivity
    date_end = process_claim.date_incident
    years = date_end.year - date_start.year
    months = date_end.month - date_start.month
    days = date_end.day - date_start.day

    if days < 0
      months -= 1
      days += (date_end.prev_month.end_of_month.day - date_start.day + date_end.day)
    end
    if months < 0
      years -= 1
      months += 12
    end
    return "#{years} years, #{months} months, #{days} days"
  end
  # belongs_to :coverageable, polymorphic: true
end
