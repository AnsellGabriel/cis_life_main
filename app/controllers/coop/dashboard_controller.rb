class Coop::DashboardController < ApplicationController
  def index
    @cooperative = current_user.userable.cooperative
    @notifications = @cooperative.notifications

    @coop_group_remits = @cooperative.group_remits
    @pending_lppi = LoanInsurance::Batch.get_pending_lppi(@coop_group_remits)
    
    #for graphs
    @age_bracket = [
      ["18-65", @cooperative.get_age_demo("regular")],
      ["66-70", @cooperative.get_age_demo("66")],
      ["71-75", @cooperative.get_age_demo("71")],
      ["76-80", @cooperative.get_age_demo("76")],
      ["81-85", @cooperative.get_age_demo("81")]
    ]

    @gender_counts = [
      ["Male", @cooperative.coop_members.includes(:member).where(member: { gender: ['Male', "MALE", "M"] }).count],
      ["Female", @cooperative.coop_members.includes(:member).where(member: { gender: ['Female', "FEMALE", "F"] }).count],
      ["Other", @cooperative.coop_members.includes(:member).where(member: { gender: ['-', nil] }).count]
    ]
  end
end
