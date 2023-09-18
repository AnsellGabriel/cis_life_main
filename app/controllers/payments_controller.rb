class PaymentsController < ApplicationController
  before_action :set_data, only: %i[create]

  def create
    if params[:file].nil?
      return no_file_redirect(@group_remit)
    end

    respond_to do |format|
      if @payment.save!
        @group_remit.status = :payment_verification
    
        if @group_remit.type == 'LoanInsurance::GroupRemit'
          format.html { redirect_to loan_insurance_group_remit_path(@group_remit), notice: "Proof of payment sent" }
        else
          return update_batch_remit(@group_remit)
        end

      else
        format.html { redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), alert: "Invalid proof of payment" }
      end
    end
  end

  private

  def set_data
    @group_remit = GroupRemit.find(params[:id])
    @agreement = @group_remit.agreement
    @payment = Payment.new(receipt: params[:file], payable_type: @group_remit.class.name, payable_id: @group_remit.id)
  end

  def no_file_redirect(group_remit)
    if group_remit.type == 'LoanInsurance::GroupRemit'
      redirect_to loan_insurance_group_remit_path(group_remit), alert: "Please attach proof of payment"
    else
      redirect_to coop_agreement_group_remit_path(group_remit.agreement, group_remit), alert: "Please attach proof of payment"
    end
  end

  def update_batch_remit(group_remit)
    approved_batches = group_remit.batches.approved
    approved_members = CoopMember.approved_members(approved_batches)
    current_batch_remit = BatchRemit.find(group_remit.batch_remit_id)
    duplicate_batches = current_batch_remit.batch_group_remits.existing_members(approved_members)

    BatchRemit.process_batch_remit(current_batch_remit, duplicate_batches, approved_batches)
    current_batch_remit.save!

    redirect_to coop_agreement_group_remit_path(group_remit.agreement, group_remit), notice: "Proof of payment uploaded"
  end

end
