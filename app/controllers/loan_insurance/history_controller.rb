class LoanInsurance::HistoryController < ApplicationController
  def index
    @coop_member = CoopMember.find(params[:coop_member_id])
    @loans = @coop_member.loans
    @pagy, @loans = pagy(@loans, items: 10)
  end
end
 