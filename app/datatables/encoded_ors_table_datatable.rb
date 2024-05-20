class EncodedOrsTableDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "GroupRemit.id", cond: :eq },
      or_no: { source: "GroupRemit.official_receipt", cond: :like },
      or_date: { source: "GroupRemit.or_date", cond: :like },
      coop: { source: "GroupRemit.coop", cond: :like },
      batches_count: { source: "GroupRemit.batches_count", cond: :like },
      plan: { source: "GroupRemit.plan", cond: :like }
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    raise 'errors'
    records.map do |record|
      {
        id: record.id,
        or_no: record.official_receipt,
        or_date: record.get_or_date,
        coop: record.agreement.cooperative,
        batches_count: record.count_batches,
        plan: record.agreement.plan.acronym
        # example:
        # id: record.id,
        # name: record.name
      }
    end
  end

  def get_raw_records
    # insert query here
    # User.all
    GroupRemit.where(mis_entry: true)
  end

end
