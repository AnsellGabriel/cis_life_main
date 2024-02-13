class PaymentService
  def initialize(payment, current_user, entry)
    @payment = payment
    @current_user = current_user
    @entry = entry
  end

  def post_payment
    group_remit = @payment.payable

    ActiveRecord::Base.transaction do
      @payment.approved!
      group_remit.paid!
      Notification.create!(notifiable: group_remit.agreement.cooperative, message: "#{group_remit.name} payment verified.")
    end

    group_remit.transaction do
      if group_remit.type == "LoanInsurance::GroupRemit"
        group_remit.update_members_total_loan
        group_remit.update_batch_coverages
        group_remit.terminate_unused_batches(@current_user)
      else
        group_remit.update_batch_remit
        group_remit.update_batch_coverages
      end

      group_remit.update(official_receipt: @entry.or_no)
    end

    "Payment posted."
  end

end
