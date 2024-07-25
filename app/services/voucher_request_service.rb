class VoucherRequestService
  def initialize(requestable, amount, request_type, current_user, payment_type = nil, bank_id = nil, refund_type = nil)
    @requestable = requestable
    @amount = amount
    @current_user = current_user
    @request_type = request_type
    @payment_type = payment_type
    @bank_id = bank_id
    @refund_type = refund_type
  end

  def create_request
    if @requestable.is_a?(ProcessCoverage)
      voucher_request = @requestable.build_voucher_request(
        amount: @amount,
        status: :pending,
        particulars: @requestable.try(:particulars).present? ? @requestable.particulars : particulars,
        request_type: @request_type,
        requester: @current_user.userable.signed_fullname,
        payment_type: @payment_type,
        account: @bank_id.present? ? CoopBank.find(@bank_id) : nil
      )
      voucher_request.save!
      und_remarks
    else
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
  end

  private

  def particulars
    if @requestable.is_a?(ProcessCoverage)
      if @refund_type == "denied"
        "Payment for #{@requestable.group_remit.agreement.plan.acronym} Premium refund for various members denied as per OR# #{or_number}"
      else
        "Refund for #{@requestable.group_remit.agreement.plan.acronym} with OR # #{@requestable.group_remit.official_receipt}"
      end
    elsif @requestable.is_a?(Claims::ProcessClaim)
      "Payment for #{@requestable.agreement.plan.acronym} #{benefit_names} benefit of #{@requestable.coop_member.get_fullname} as per claim date filed #{@requestable.date_file.strftime("%m/%d/%Y")}. Incident Date #{@requestable.date_incident.strftime("%m/%d/%Y")}"
    end
  end

  def or_number
    @requestable.group_remit.official_receipt.present? ? @requestable.group_remit.official_receipt : @requestable.get_or_number
  end

  def und_remarks
    @requestable.process_remarks.create!(
      remark: "Premium Refund request created!",
      status: :refund_request,
      user: @current_user
    )
  end

  def benefit_names
    benefit_names = []

    @requestable.claim_benefits.each do |benefit|
      benefit_names << benefit.benefit.name
    end

    benefit_names.join(", ")
  end
end
