# app/controllers/concerns/csv_generator.rb

module CsvGenerator
  extend ActiveSupport::Concern

  def generate_csv(data, filename, balance = nil)
    case data.first.class.name
    when "GeneralLedger"
      csv_data = account_ledger(data, balance)
    else
      csv_data = generic_data(data)
    end

    send_data csv_data, filename: "#{filename}.csv", type: "text/csv"
  end

  def generic_data(data)
    rejected_attributes = %w[id created_at updated_at group_remit_id]

    csv_data = CSV.generate(headers: true) do |csv|
      csv << data.first.attributes.keys.reject { |key| rejected_attributes.include?(key) }

      data.each do |record|
        values = record.attributes.reject { |key, value| rejected_attributes.include?(key) }
        csv << values
      end
    end

    csv_data
  end

  def account_ledger(data, balance)
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Initial Balance", number_to_currency(balance, unit: "")]
      csv << ["Reference", "Date", "Payee", "Description", "Debit", "Credit", "Balance"]

      data.each do |record|
        debit = record.debit? ? record.amount : 0
        credit = record.credit? ? record.amount : 0
        balance += debit - credit

        csv << [record.ledgerable.reference, record.transaction_date.strftime("%B %d, %Y"), record.payee, record.description, number_to_currency(debit, unit: ""), number_to_currency(credit, unit: ""), number_to_currency(balance, unit: "")]
      end

      csv << ["End Balance", number_to_currency(balance, unit: "")]
    end

    csv_data
  end
end
