class Coop::DashboardController < ApplicationController
  def index
    @coop = current_user.userable.cooperative
    @notifications = @coop.notifications
  end
end
