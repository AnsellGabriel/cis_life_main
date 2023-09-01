module RemittanceHelper
  def unsubmitted_remittance?(group_remit)
    (group_remit.pending? || group_remit.for_renewal?) && group_remit.instance_of?(Remittance)
  end
end