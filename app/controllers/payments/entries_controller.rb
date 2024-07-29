class Payments::EntriesController < ApplicationController
  before_action :set_payment_and_entries, only: %i[new create show edit update cancel post]

  def index
  end

  def show
    @entry = @entries.find(params[:id])
    @ledgers = @entry.general_ledgers
    @bills = @entry.bills
  end

  def new
    last_series = Treasury::CashierEntry.all.present? ? Treasury::CashierEntry.last.or_no.to_i + 1 : 1
    @entry = @entries.new(or_no: last_series, or_date: Date.today)
    @payment_type = @payment.plan.acronym.downcase.include?("gyrt") ? "GYRT" : @payment.plan.acronym
  end

  def create
    @entry = @entries.new(entry_params.merge(employee: current_user.userable, insurance: true))
    @entry.branch = current_user.userable.branch
    @payment_type = @payment.plan.acronym.downcase.include?("gyrt") ? "GYRT" : @payment.plan.acronym

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
    @entry.general_ledgers.update_all(transaction_date: nil)

    redirect_to payment_entry_path(@payment, @entry), notice: "OR cancelled"
  end

  private

  def entry_params
    params.require(:treasury_cashier_entry).permit(:vatable, :vatable_amount, :vat_exempt, :zero_rated, :vat, :particulars, :deposit, :service_fee, :branch_id,:unuse, :dummy_payee, :dummy_entry_type, :or_no, :or_date, :treasury_account_id, :amount, general_ledgers_attributes: [:account_id, :amount, :ledger_type, :id, :_destroy])
  end

  def set_payment_and_entries
    @payment = Payment.find(params[:payment_id])
    @entries = @payment.entries
  end
end
