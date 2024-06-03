require "sidekiq-scheduler"

class GroupRemitPaymentStatusUpdater
  include Sidekiq::Job

  def perform
    paid_group_remits = Payment.pluck(:payable_id, :payable_type)
    gr_ids = paid_group_remits.map { |gr| gr[0]}
    gr_type = paid_group_remits.map { |gr| gr[1]}
    approved_remittances = GroupRemit.includes(:process_coverage).where(process_coverage: { status: :approved}).where.not(id: gr_ids, type: gr_type)


    approved_remittances.each do |remit|
      1st_notice = remit.process_coverage.evaluate_date + 15.days #date approved
      2nd_notice = remit.process_coverage.evaluate_date + 30.days #date approved
      3rd_notice = remit.process_coverage.evaluate_date + 45.days #date approved

      if 1st_notice == Date.today
        remit.process_coverage.notifications.build(
          message: "Please upload proof of payment for remittance: #{remit.name} because it has been 15 days since the approval of coverages.",
          notifiable: remit.agreement.cooperative
        )
      elsif 2nd_notice == Date.today
        remit.process_coverage.notifications.build(
          message: "Please upload proof of payment for remittance: #{remit.name} because it has been 30 days since the approval of coverages.",
          notifiable: remit.agreement.cooperative
        )
      elsif 3rd_notice == Date.today
        remit.process_coverage.notifications.build(
          message: "Failure to upload proof of payment for coverages of #{remit.name} will be cancelled today.",
          notifiable: remit.agreement.cooperative
        )
      end
    end
  end
end