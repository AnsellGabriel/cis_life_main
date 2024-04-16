# app/controllers/concerns/csv_generator.rb

module CsvGenerator
  extend ActiveSupport::Concern
  def generate_csv(data, filename, balance = nil)
    case data.first.class.name
    when "GeneralLedger"
      csv_data = account_ledger(data, balance)
    when "ProcessCoverage"
      csv_data = und_data(data)
    else
      csv_data = generic_data(data)
    end

    send_data csv_data, filename: "#{filename}.csv", type: "text/csv"
  end

  def ri_generate_csv(data, filename, ri_start, ri_end)
    csv_data = ri_data(data, ri_start, ri_end)

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

  def und_data(data)
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Code", "Cooperative", "Plan", "Marketing", "Gross Premium", "Coop Service Fee", "Agent Commission", "Net Premium", "Region", "Date", "Processor", "Status"]

      data.each do |record|        
        csv << [
          record.id,
          record.group_remit&.cooperative,
          record.group_remit&.agreement&.plan,
          record.agent,
          record.group_remit&.gross_premium,
          record.group_remit&.coop_commission,
          record.group_remit&.agent_commission,
          record.group_remit&.read_attribute(:net_premium),
          record.group_remit&.agreement&.cooperative&.geo_region,
          record.created_at,
          record&.processor,
          record.status
        ]
      end
    end

    csv_data
  end

  def ri_data(data, ri_start, ri_end)
    # raise 'errors'
    months = (ri_start..ri_end).map { |d| d.strftime("%B") }.uniq
    csv_data = CSV.generate(headers: true) do |csv|
      # csv << ["Code", "Cooperative", "CoopMember Code", "Member Code", "Last Name", "First Name", "MI", "Suffix", "Birthday", "Age", "Gender", "Effectivity", "Expiry", "Terms", "Loan Amount", "Premium", "RI Effect", "RI Expire", "RI Terms"]
      header_row = ["Code", "Cooperative", "CoopMember Code", "Member Code", "Last Name", "First Name", "MI", "Suffix", "Birthday", "Age", "Gender", "Effectivity", "Expiry", "Terms", "Loan Amount", "Premium", "RI Effect", "RI Expire", "RI Terms"]
      header_row += months
      csv << header_row

      data.each do |record|
        monthly_total = []
        record.reinsurance_batches.each do |ri_batch|
          csv << [
            ri_batch.batch&.id,
            ri_batch.batch&.coop_member&.cooperative,
            ri_batch.batch&.coop_member.id,
            record.member.id,
            record.member&.last_name,
            record.member&.first_name,
            record.member&.middle_name,
            record.member&.suffix,
            record.member&.birth_date,
            ri_batch.batch&.age,
            record.member&.gender,
            ri_batch.batch&.effectivity_date,
            ri_batch.batch&.expiry_date,
            ri_batch.batch&.terms,
            ri_batch.batch&.loan_amount,
            ri_batch.batch&.premium_due,
            ri_batch&.ri_effectivity,
            ri_batch&.ri_expiry,
            ri_batch&.ri_terms
          ]
        end
        months.each do |ctr|
          date = Date.parse(ctr)
          monthly_total += [(record.sum_loan_amount_per_month(date.beginning_of_month, date.end_of_month) - @retention_limit)]
        end
        empty_columns_count = ["Code", "Cooperative", "CoopMember Code", "Member Code", "Last Name", "First Name", "MI", "Suffix", "Birthday", "Age", "Gender", "Effectivity", "Expiry", "Terms", "Loan Amount", "Premium", "RI Effect", "RI Expire", "RI Terms"].count - 2
        empty_columns = [""] * empty_columns_count
        csv << empty_columns + [ "RI Amount: ", (record.sum_loan_amount - @retention_limit)] + monthly_total
      end
    end
    csv_data
  end

  # def product_monitor(data)

  # end
end
