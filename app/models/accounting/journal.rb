class Accounting::Journal < Accounting::Voucher
  validates_presence_of :voucher

  # has_many :general_ledgers, as: :ledgerable

  def self.journal_book_pdf(employee_id, date_from, date_to, type)
    Reports::BooksPdfJob.perform_async(employee_id, date_from, date_to, type)
  end

  def reference
    voucher
  end

  def entry_type
    'jv'
  end

  private

  def self.generate_series
    formatted_year_and_month = Time.now.strftime("%Y-%m")[0, 1] + Time.now.strftime("%Y-%m")[1 + 1..-1]
    last_series = self.where("voucher LIKE ?", "#{formatted_year_and_month}%")
                  .order(:voucher).last&.voucher

    if last_series.present?
      series = last_series[0..6] + sprintf("%03d", last_series[-3..-1].to_i + 1)
    else
      series = formatted_year_and_month + "-001"
    end

    series
  end

  def self.ransackable_attributes(auth_object = nil)
    ["voucher"]
  end
end
