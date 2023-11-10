class LoanInsurance::HistoryController < ApplicationController
  def index
    @coop_member = CoopMember.find(params[:coop_member_id])
    @loans = @coop_member.loans.decorate
    @pagy, @loans = pagy(@loans, items: 10)
    @table_headers = [
      "Date Created",
      "Type",
      "Amount",
      "Effectivity",
      "Expiry",
      "Terms",
      "Release",
      "Maturity",
      "Premium",
      "Unused",
      "Excess",
      "Premium Due",
      "Status"
    ]
  end
end
