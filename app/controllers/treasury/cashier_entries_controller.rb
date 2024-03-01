class Treasury::CashierEntriesController < ApplicationController
  before_action :set_entry, only: %i[ show edit update cancel ]
  before_action :set_entriables, only: %i[ new create edit update]

  def download
    @receipt = Treasury::CashierEntry.find(params[:id])
    @entry = @receipt.entriable
    @amount_in_words = amount_to_words(@receipt.amount)
    @payment_type = payment_type(@receipt.payment_type)
    @vat = @receipt.vat

    # binding.pry
    respond_to do |format|
      format.pdf do
        render pdf: "OR##{@receipt.or_no}",
               page_size: "A4"
      end
    end
  end

  def print
    @receipt = Treasury::CashierEntry.find(params[:id])
    @entry = @receipt.entriable
    @amount_in_words = amount_to_words(@receipt.amount)
    @payment_type = payment_type(@receipt.payment_type)
    @vat = @receipt.vat

    # binding.pry
    respond_to do |format|
      format.pdf do
        render pdf: "OR##{@receipt.or_no}",
               page_size: "A4"
      end
    end
  end

  def index
    @entry = Treasury::CashierEntry.new

    if params[:or_number].present?
      @entries = Treasury::CashierEntry.where(or_no: params[:or_number])
    else
      @entries = Treasury::CashierEntry.all.order(created_at: :desc)
    end

    @pagy, @entries = pagy(@entries, items: 10)
  end

  def for_approval_index
    @entries = Treasury::CashierEntry.where(status: :for_approval).order(created_at: :desc)

    @pagy, @entries = pagy(@entries, items: 10)
  end

  def show
    @coop = @entry.entriable
    @ledgers = @entry.general_ledgers
    @bills = @entry.bills
  end

  def new
    @entry = Treasury::CashierEntry.new(or_no: Treasury::CashierEntry.last&.or_no.to_i + 1, or_date: Date.today)

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
      # if @entry.entriable_type == "Remittance"
      #   approve_payment(@group_remit.payments.last.id)
      # end

      redirect_to @entry, notice: "Entry added"
    else
      render :new, status: :unprocessable_entity
    end

  end

  # def autofill
  #   @entry.autofill(@entry.entriable)

  #   redirect_to payment_entry_path(params[:p_id], @entry), notice: "Ledger entries added!"
  # end

  def update
    if @entry.update(entry_params)
      redirect_to @entry, notice: "Entry updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    if @entry.cancelled!
      redirect_to treasury_cashier_entry_path(@entry), notice: "OR cancelled"
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
    params.require(:treasury_cashier_entry).permit(:or_no, :or_date, :global_entriable, :payment_type, :treasury_account_id, :amount)
  end

  def amount_to_words(amount)
    # Convert the integer part to words
    integer_part_words = amount.to_i.to_words

    # Convert the decimal part to words
    decimal_part = (amount.modulo(1) * 100).to_i

    # Format the result
    result = "#{integer_part_words.titleize} Pesos and #{decimal_part}/100 only"
  end

  def payment_type(type)
    case type
    when "lppi"
      "LOAN PAYMENT PROTECTION INSURANCE (LPPI)"
    when "gyrt"
      "GROUP YEARLY RENEWABLE TERM (GYRT)"
    else
      type.titleize
    end
  end
end
