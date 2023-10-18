namespace :clean_up_record do
  desc "Delete records not from maintenance tables"
  task delete_records: :environment do
    # tables_to_truncate = %w[batches loan_insurance_batches process_coverages group_remits agreements agreementsu_coop_members anniversaries batch_beneficiaries batch_dependents batch_group_remits batch_health_decs batch_remarks coop_members coop_users denied_enrollees denied_members dependent_health_decs dependent_remarks emp_agreements loan_insurance_loans members member_dependents payments process_coverages process_remarks product_benefits proposals group_proposals reinsurances]
    tables_to_truncate = %w[agreement_benefits]
    
    tables_to_truncate.each do |table_name|
      ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0;")
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name};")
      ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 1;")
    end

    puts "Tables truncated successfully!"
  end
end