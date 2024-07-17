class Claims::ClaimCoverage < ApplicationRecord
  belongs_to :process_claim
  belongs_to :batch, optional: true
  # belongs_to :coverageable, polymorphic: true

  Coverage_status = ["Current", "Previous"]
  Status = ["Approved", "Denied", "Pending", "Reconsider"]

  def get_duration
    years = expiry.year - process_claim.date_file.year
    months = expiry.month - effectivity.month
    days = expiry.day - effectivity.day

    if days < 0
      months -= 1
      days += (expiry.prev_month.end_of_month.day - effectivity.day + expiry.day)
    end
    if months < 0
      years -= 1
      months += 12
    end
    return "#{years} years, #{months} months, #{days} days"
  end
  # belongs_to :coverageable, polymorphic: true
end
