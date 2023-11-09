class PaymentsController < ApplicationController
  before_action :initialize_payment_data, only: %i[create]

  def index
    @payments = Payment.all.includes(payable: {agreement: [:cooperative, :plan]}).order(updated_at: :desc)
    @pagy, @payments = pagy(@payments, items: 10)
  end

  def create
    if params[:file].nil?
      return no_file_redirect(@group_remit)
    end

    respond_to do |format|
      if @payment.save!
        @group_remit.update(status: :payment_verification)

        if @group_remit.type == 'LoanInsurance::GroupRemit'
          format.html { redirect_to loan_insurance_group_remit_path(@group_remit), notice: "Proof of payment uploaded" }
        else
          format.html { redirect_to coop_agreement_group_remit_path(@agreement, @group_remit), notice: "Proof of payment uploaded" }
        end

      else
        format.html { redirect_to coop_agreement_group_remit_path(@agreement, @group_remit), alert: "Invalid proof of payment" }
      end
    end
  end

  private

  def initialize_payment_data
    @group_remit = GroupRemit.find(params[:group_remit_id])
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

  # def create_or_update_coverage

end
