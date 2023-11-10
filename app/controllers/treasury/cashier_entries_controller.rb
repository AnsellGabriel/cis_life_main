class Treasury::CashierEntriesController < ApplicationController
  before_action :set_entry, only: %i[ show edit update destroy ]
  before_action :set_entriables, only: %i[ new create edit update]

  def index
    @entry = Treasury::CashierEntry.new

    if params[:or_number].present?
      @entries = Treasury::CashierEntry.where(or_no: params[:or_number])
    else
      @entries = Treasury::CashierEntry.all.order(created_at: :desc)
    end

    @pagy, @entries = pagy(@entries, items: 10)
  end

  def show
  end

  def new
    @entry = Treasury::CashierEntry.new(or_no: Treasury::CashierEntry.last&.or_no.to_i + 1, or_date: Date.today)
    @payment = @entry.payments.build

    if params[:gr_id].present?
      @group_remit = GroupRemit.find(params[:gr_id])
      @entry.amount = @group_remit.coop_net_premium
      @entry.payment = Treasury::CashierEntry.payments[@group_remit.agreement.plan.acronym.downcase]
    end

  end

  def edit
  end

  def create
    @entry = Treasury::CashierEntry.new(entry_params)

    if @entry.entriable_type == "Remittance"
      @group_remit = @entry.entriable
    end

    if @entry.save
      if @entry.entriable_type == "Remittance"
        approve_payment(@group_remit.payments.last.id)
      end

      redirect_to @entry, notice: "Entry added"
    else
      render :new, status: :unprocessable_entity
    end

  end

  def update
    if @entry.update(entry_params)
      redirect_to @entry, notice: "Entry updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @entry.destroy
      redirect_to treasury_cashier_entries_path, notice: "Entry deleted", status: :see_other
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_entry
    @entry = Treasury::CashierEntry.find(params[:id])
  end

  def set_entriables
    @entriables = Cooperative.all.order(:name)
  end

  # Only allow a list of trusted parameters through.
  def entry_params
    params.require(:treasury_cashier_entry).permit(:or_no, :or_date, :global_entriable, :payment, :treasury_account_id, :amount, payments_attributes: [:id, :payment_type, :check_no, :amount, :account_id, :_destroy])
  end

  def approve_payment(payment_id)
    payment = Payment.find(payment_id)
    group_remit = payment.payable

    if payment.approved!
      group_remit.paid!
      Notification.create(notifiable: group_remit.agreement.cooperative, message: "#{group_remit.name} payment verified.")

      if group_remit.type == "LoanInsurance::GroupRemit"
        group_remit.update_members_total_loan
        group_remit.update_batch_coverages
        group_remit.terminate_unused_batches(current_user)
      else
        group_remit.update_batch_remit
        group_remit.update_batch_coverages
      end

    end
  end

end
