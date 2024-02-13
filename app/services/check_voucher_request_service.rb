class CheckVoucherRequestService
  def initialize(requestable, amount, current_user)
    @requestable = requestable
    @amount = amount
    @current_user = current_user
  end

  def create_request
    @requestable.create_check_voucher_request(
      amount: @amount,
      status: :pending,
      description: description,
      analyst: @current_user.userable.signed_fullname
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
