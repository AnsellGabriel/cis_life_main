require 'sidekiq-scheduler'

class GroupRemitStatusUpdater
	include Sidekiq::Job

  def perform
    GroupRemit.where(status: :active)
      .where("expiry_date <= ?", Date.current)
      .update(status: :expired)
  end

end

