class BatchRemit < GroupRemit
  def self.process_batch_remit(batch_remit, approved_batches)
    # batch_remit.batch_group_remits.destroy(duplicate_batches)
    batch_remit.batch_group_remits.destroy_all
    batch_remit.batches << approved_batches
    batch_remit.set_total_premiums_and_fees
    batch_remit.status = :paid
  end
end
