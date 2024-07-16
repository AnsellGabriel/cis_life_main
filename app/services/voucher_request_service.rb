class VoucherRequestService
  def initialize(requestable, amount, request_type, current_user, payment_type, bank_id = nil)
    @requestable = requestable
    @amount = amount
    @current_user = current_user
    @request_type = request_type
    @payment_type = payment_type
    @bank_id = bank_id
  end

  def create_request
    # request = Accounting::VoucherRequest.find_or_initialize_by(requestable: @requestable)
    @requestable.voucher_requests.create!(
      amount: @amount,
      status: :pending,
      particulars: @requestable.try(:particulars).present? ? @requestable.particulars : particulars,
      request_type: @request_type,
      requester: @current_user.userable.signed_fullname,
      payment_type: @payment_type,
      account: @bank_id.present? ? CoopBank.find(@bank_id) : nil
    )
  end

  private

  def particulars
    if @requestable.is_a?(ProcessCoverage)
      "Refund for #{@requestable.group_remit.agreement.plan.acronym} with OR # #{@requestable.group_remit.official_receipt}"
    elsif @requestable.is_a?(Claims::ProcessClaim)
      "Payment for #{@requestable.agreement.plan.acronym} #{benefit_names} benefit of #{@requestable.coop_member.get_fullname} as per claim date filed #{@requestable.date_file.strftime("%m/%d/%Y")}. Incident Date #{@requestable.date_incident.strftime("%m/%d/%Y")}"
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
