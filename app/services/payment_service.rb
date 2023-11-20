class PaymentService
  def initialize(payment, current_user)
    @payment = payment
    @current_user = current_user
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
    end

    "Payment posted."
  end

end
