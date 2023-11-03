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
    @entry = Treasury::CashierEntry.new(or_no: Treasury::CashierEntry.last&.or_no.to_i + 1)
  end

  def edit
  end

  def create
    @entry = Treasury::CashierEntry.new(entry_params)

    if @entry.save
      redirect_to treasury_cashier_entries_path, notice: "Entry added"
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
    params.require(:treasury_cashier_entry).permit(:or_no, :or_date, :global_entriable, :payment, :treasury_account_id, :amount)
  end
end
