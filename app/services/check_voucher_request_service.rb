class CheckVoucherRequestService
  def initialize(requestable, amount, payment_type, current_user, payout_type, bank_id = nil)
    @requestable = requestable
    @amount = amount
    @current_user = current_user
    @payment_type = payment_type
    @payout_type = payout_type
    @bank_id = bank_id
  end

  def create_request
    @requestable.create_check_voucher_request!(
      amount: @amount,
      status: :pending,
      description: description,
      payment_type: @payment_type,
      analyst: @current_user.userable.signed_fullname,
      payout_type: @payout_type,
      bank_id: @bank_id
    )

    true
  end

  private

  def description
    if @requestable.is_a?(ProcessCoverage)
      "Refund for #{@requestable.group_remit.agreement.plan.acronym} with OR # #{@requestable.group_remit.official_receipt}"
    elsif @requestable.is_a?(ProcessClaim)
      "Claim payment: #{@requestable.cooperative}"
    end
  end
end
