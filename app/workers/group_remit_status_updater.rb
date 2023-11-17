require "sidekiq-scheduler"

class GroupRemitStatusUpdater
  include Sidekiq::Job

  def perform
    expired_group_remit = GroupRemit.where(status: :paid)
      .where("expiry_date <= ?", Date.current)

    expired_group_remit.each do |gr|
      gr.update(status: :expired)

      unless gr.type == "Remittance"
        gr.agreement.cooperative.notifications.create(message: "#{gr.name} has expired. Please renew.")
      end

    end
  end

end
