class ProcessClaimPresenter
  def initialize(process_claim)
    @process_claim = process_claim
  end

  def present_active_class(tracker_pos)
    if @process_claim.claim_route_before_type_cast >= tracker_pos
      "active"
    else
      ""
    end
  end


end
