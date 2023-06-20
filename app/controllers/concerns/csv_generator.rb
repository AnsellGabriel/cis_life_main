# app/controllers/concerns/csv_generator.rb

module CsvGenerator
  extend ActiveSupport::Concern

  def generate_csv(data, filename)
    rejected_attributes = %w[id created_at updated_at group_remit_id]

    csv_data = CSV.generate(headers: true) do |csv|
      csv << data.first.attributes.keys.reject { |key| rejected_attributes.include?(key) }

      data.each do |record|
        values = record.attributes.reject { |key, value| rejected_attributes.include?(key) }
        csv << values
      end
    end

    send_data csv_data, filename: "#{filename}.csv", type: 'text/csv'
  end
end
