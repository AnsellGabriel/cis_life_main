class Coop::DashboardController < ApplicationController
  def index
    @coop = current_user.userable.cooperative
    @notifications = @coop.notifications
    
    #for graphs
    @age_bracket = [
      ["18-65", @coop.get_age_demo("regular")],
      ["66-70", @coop.get_age_demo("66")],
      ["71-75", @coop.get_age_demo("71")],
      ["76-80", @coop.get_age_demo("76")],
      ["81-85", @coop.get_age_demo("81")]
    ]

    @gender_counts = [
      ["Male", @coop.coop_members.includes(:member).where(member: { gender: ['Male', "MALE", "M"] }).count],
      ["Female", @coop.coop_members.includes(:member).where(member: { gender: ['Female', "FEMALE", "F"] }).count],
      ["Other", @coop.coop_members.includes(:member).where(member: { gender: ['-', nil] }).count]
    ]
  end
end
