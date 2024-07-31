class AnalyticsController < ApplicationController
  def claims 
    start_date = params[:start_date] || 30.days.ago.to_date
    end_date = params[:end_date] || Date.today
    @process_claims = Claims::ProcessClaim.all
  end
end
