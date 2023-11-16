class Payments::EntriesController < ApplicationController
  before_action :set_payment_and_entries, only: %i[new create show edit update cancel post]

  def index
  end

  def show
    @entry = @entries.find(params[:id])
    @ledgers = @entry.general_ledgers
  end

  def new
    @entry = @entries.new(or_no: Treasury::CashierEntry.last&.or_no.to_i + 1, or_date: Date.today)
  end

  def create
    @entry = @entries.new(entry_params)
    @entry.payment = Treasury::CashierEntry.payment_enum_value(@payment.plan.acronym.downcase)

    if @entry.save
      redirect_to payment_entry_path(@payment, @entry), notice: "OR added"
    else
      render :new, status: :unprocessable_entity
    end

  end

  def edit
    @entry = @entries.find(params[:id])
  end

  def update
    @entry = @entries.find(params[:id])

    if @entry.update(entry_params)
      redirect_to payment_entry_path(@payment, @entry), notice: "OR updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  

  def cancel
    @entry = @entries.find(params[:id])
    @entry.cancelled!

    redirect_to payment_entry_path(@payment, @entry), notice: "OR cancelled"
  end

  private

  def entry_params
    params.require(:treasury_cashier_entry).permit(:or_no, :or_date, :treasury_account_id, :amount, general_ledgers_attributes: [:account_id, :amount, :ledger_type, :id, :_destroy])
  end

  def set_payment_and_entries
    @payment = Payment.find(params[:payment_id])
    @entries = @payment.entries
  end
end
