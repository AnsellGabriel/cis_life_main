require 'sidekiq-scheduler'

class GroupRemitStatusUpdater
	include Sidekiq::Job

  def perform
    GroupRemit.where(status: :paid)
      .where("expiry_date <= ?", Date.current)
      .update(status: :expired)
  end

end

