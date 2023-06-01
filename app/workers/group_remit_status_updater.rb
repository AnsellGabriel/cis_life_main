require 'sidekiq-scheduler'

class GroupRemitStatusUpdater
	include Sidekiq::Worker

  def perform
    GroupRemit.where(status: :active)
      .where("expiry_date <= ?", Date.current)
      .update_all(status: :expired)
  end

end

