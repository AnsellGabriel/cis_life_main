class GeneralLedgersController < ApplicationController
  before_action :set_entry_and_ledgers, only: %i[new create destroy edit update post]

  def post
    if @ledgers.total_debit != @ledgers.total_credit
      return redirect_to payment_entry_path(@entry.entriable, @entry), alert: "Unable to post ledger, credit and debit total not equal."
    end

    if @entry.update(status: :posted)
      @entry.entriable.paid

      redirect_to payment_entry_path(@entry.entriable, @entry), notice: "OR posted"
    end
  end

  def index
    @general_ledgers = GeneralLedger.all
  end

  def show
  end

  # GET /entries/:entry_id/ledger/new
  def new
    @ledger = @ledgers.new
  end

  def edit
    @ledger = @ledgers.find(params[:id])
  end

  def create
    @ledger = @ledgers.new(general_ledger_params)

    if @ledger.save
      redirect_to payment_entry_path(@entry.entriable, @entry), notice: "Entry added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @ledger = @ledgers.find(params[:id])

    if @ledger.update(general_ledger_params)
      redirect_to payment_entry_path(@entry.entriable, @entry), notice: "Entry updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ledger = @ledgers.find(params[:id])

    if @ledger.destroy
      redirect_to payment_entry_path(@entry.entriable, @entry), alert: "Entry deleted.", status: :see_other
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_general_ledger
      @general_ledger = GeneralLedger.find(params[:id])
    end

    def set_entry_and_ledgers
      @entry = Treasury::CashierEntry.find(params[:entry_id])
      @ledgers = @entry.general_ledgers
    end

    # Only allow a list of trusted parameters through.
    def general_ledger_params
      params.require(:general_ledger).permit(:description, :account_id, :amount, :ledger_type)
    end
end
