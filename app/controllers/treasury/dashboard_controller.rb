class Treasury::DashboardController < ApplicationController
  def index
    @for_approvals = Treasury::CashierEntry.where(status: :for_approval).order(created_at: :desc)
  end

  def for_approval
    @for_approvals = Treasury::CashierEntry.where(status: :for_approval).order(created_at: :desc)
  end
end
