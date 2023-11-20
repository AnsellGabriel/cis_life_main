class DependentPresenter
  def initialize(dependent)
    @dependent = dependent
  end

  def status_badge
    case @dependent.insurance_status
    when "for_review", "pending"
      "badge bg-warning text-dark"
    when "approved"
      "badge bg-primary"
    when "denied"
      "badge bg-danger"
    end
  end
end
