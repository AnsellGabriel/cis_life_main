class Payments::EntriesController < ApplicationController
  before_action :set_payment_and_entries, only: %i[ index new create show]

  def index
  end

  def show
    @entry = @entries.find(params[:id])
  end

  def new
    @entry = @entries.new(or_no: Treasury::CashierEntry.last&.or_no.to_i + 1, or_date: Date.today)
  end

  def create
    @entry = @entries.new(entry_params)

    if @entry.save
      redirect_to @entry, notice: "Entry added"
    else
      render :new, status: :unprocessable_entity
    end

  end

  def edit
  end

  private

  def entry_params
    params.require(:treasury_cashier_entry).permit(:or_no, :or_date, :payment, :treasury_account_id, :amount)
  end

  def set_payment_and_entries
    @payment = Payment.find(params[:payment_id])
    @entries = @payment.entries
  end
end
