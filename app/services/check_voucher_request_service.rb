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
    request = @requestable.check_voucher_request
    if request.present?
      request.update!(
        amount: @amount,
        status: :posted,
        description: description,
        payment_type: @payment_type,
        analyst: @current_user.userable.signed_fullname,
        payout_type: @payout_type,
        bank_id: @bank_id
      )
    else
      @requestable.create_check_voucher_request!(
        amount: @amount,
        status: :pending,
        description: description,
        payment_type: @payment_type,
        analyst: @current_user.userable.signed_fullname,
        payout_type: @payout_type,
        bank_id: @bank_id
      )
    end

    true
  end

  private

  def description
    if @requestable.is_a?(ProcessCoverage)
      "Refund for #{@requestable.group_remit.agreement.plan.acronym} with OR # #{@requestable.group_remit.official_receipt}"
    elsif @requestable.is_a?(ProcessClaim)
      "Payment for #{@requestable.agreement.plan.acronym} #{benefit_names} benefit of #{@requestable.claimable.full_name} as per claim date filed #{@requestable.date_file.strftime("%m/%d/%Y")}. Incident Date #{@requestable.date_incident.strftime("%m/%d/%Y")}"
    end
  end

  def benefit_names
    benefit_names = []

    @requestable.claim_benefits.each do |benefit|
      benefit_names << benefit.benefit.name
    end

    benefit_names.join(", ")
  end
end
