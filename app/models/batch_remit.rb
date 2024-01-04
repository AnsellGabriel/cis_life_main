class BatchRemit < GroupRemit
  def self.process_batch_remit(batch_remit, approved_batches)
    if approved_batches.renewal.present?
      batch_remit.batch_group_remits.destroy_all
    end

    batch_remit.batches << approved_batches
    batch_remit.set_total_premiums_and_fees
    batch_remit.status = :paid
    batch_remit.save!
  end

  def paid_remittances
    Remittance.paid.where(batch_remit_id: id).where(expiry_date: expiry_date)
  end
end
