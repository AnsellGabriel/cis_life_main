require 'sidekiq-scheduler'

class GroupRemitStatusUpdater
	include Sidekiq::Worker

  def perform
    GroupRemit.where(status: [:active, :renewed])
      .where("expiry_date <= ?", Date.current)
      .update(status: :expired)
  end

end

