require "sidekiq-scheduler"

class GroupRemitPaymentStatusUpdater
  include Sidekiq::Job

  def perform
    paid_group_remits = Payment.pluck(:payable_id, :payable_type)
    gr_ids = paid_group_remits.map { |gr| gr[0]}
    gr_type = paid_group_remits.map { |gr| gr[1]}
    approved_remittances = GroupRemit.includes(:process_coverage).where(process_coverage: { status: :approved}).where.not(id: gr_ids, type: gr_type)


    approved_remittances.each do |remit|
      first_notice = remit.process_coverage.evaluate_date + 15.days 
      second_notice = remit.process_coverage.evaluate_date + 30.days 
      third_notice = remit.process_coverage.evaluate_date + 45.days

      if first_notice == Date.today
        remit.process_coverage.notifications.build(
          message: "Please upload proof of payment for remittance: #{remit.name} because it has been 15 days since the approval of coverages.",
          notifiable: remit.agreement.cooperative
        )
      elsif second_notice == Date.today
        remit.process_coverage.notifications.build(
          message: "Please upload proof of payment for remittance: #{remit.name} because it has been 30 days since the approval of coverages.",
          notifiable: remit.agreement.cooperative
        )
      elsif third_notice == Date.today
        remit.process_coverage.notifications.build(
          message: "Failure to upload proof of payment for coverages of #{remit.name} will be cancelled today.",
          notifiable: remit.agreement.cooperative
        )
      elsif third_notice < Date.today
        user = remit.agreement.cooperative.coop_users.first.user
        remit.remarks.create(remark: "Coverages denied due to non-uploading proof of payment.", user: user)
        remit.batches.update(insurance_status: :denied)
        remit.process_coverage.update(status: :denied)
        remit.update(status: :expired)
      end
    end
  end
end