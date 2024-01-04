class Treasury::CashierEntriesController < ApplicationController
  before_action :set_entry, only: %i[ show edit update cancel ]
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

  def update
    if @entry.update(entry_params)
      redirect_to @entry, notice: "Entry updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    @entry.cancelled!

    redirect_to treasury_cashier_entry_path(@entry), notice: "OR cancelled"
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

end
