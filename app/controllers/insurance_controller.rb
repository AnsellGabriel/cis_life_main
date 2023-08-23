class InsuranceController < ApplicationController
  before_action :set_variables, only: [:accept, :terminate]

  def accept
    @batch.accept_insurance

    respond_to do |format|
      if @batch.save!
        @group_remit.process_coverage.update(status: :reconsiderations_processed)
        format.html { redirect_to group_remit_path(@group_remit), notice: "Member added from the insurance" }
      else
        format.html { redirect_to group_remit_path(@group_remit), alert: "Member not added" }
      end
    end
  end

  # def reject
  # end

  def terminate
    agreement = @group_remit.agreement
    existing_coverage = agreement.agreements_coop_members.find_by(coop_member_id: @batch.coop_member.id)

    respond_to do |format|
      if existing_coverage.update(
        status: 'terminated', 
        expiry: @batch.previous_expiry_date, 
        effectivity: @batch.previous_effectivity_date
      )
        @batch.update(status: :terminated, insurance_status: :denied)
        format.html { redirect_to group_remit_path(@group_remit), alert: "Member insurance coverage terminated" }
      else
        format.html { redirect_to group_remit_path(@group_remit), alert: "Unsuccessful insurance coverage termination" }
      end
    end
  end

  private

  def set_variables
    @batch = Batch.find(params[:batch])
    @group_remit = GroupRemit.find(params[:group_remit])
  end
end
