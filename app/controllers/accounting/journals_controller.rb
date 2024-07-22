class Accounting::JournalsController < ApplicationController
  include Accounting::Filterable

  before_action :set_journal, only: %i[ show edit update destroy download]
  before_action :set_payables, only: %i[ new edit create update]

  def download
    @ledger_entries = @journal.general_ledgers
    @accountant = @journal.employee
    @approver = Employee.find(@journal.approved_by) if @journal.approved_by.present?
    @certifier = Employee.find(@journal.certified_by) if @journal.certified_by.present?

    respond_to do |format|
      format.pdf do
        render pdf: "Check voucher ##{@journal.voucher}",
               page_size: "A4"
      end
    end
  end

  def for_approval_index
    @journals = Accounting::Journal.where(status: :for_approval).order(created_at: :desc)

    @pagy, @journals = pagy(@journals, items: 10)
  end

  # GET /accounting/journals
  def index
    if params[:e].present?
      @journals = Accounting::Journal.where(employee: params[:e])
    else
      @journals = Accounting::Journal.all
    end

    @q = @journals.ransack(params[:q])
    filtered_and_paginated_vouchers # concerns/accounting/filterable.rb
  end

  def requests
    # @q = Accounting::DebitAdvice.where(payout_status: :paid).order(created_at: :desc).ransack(params[:q])
    @q = Accounting::VoucherRequest.all.order(created_at: :desc).ransack(params[:q])
    @requests = @q.result
    @pagy, @requests = pagy(@requests, items: 10)
  end

  # GET /accounting/journals/1
  def show
    @ledgers = @journal.general_ledgers
  end

  # GET /accounting/journals/new
  def new
    if params[:rid].present?
      @request = Accounting::VoucherRequest.find(params[:rid])
    end

    if params[:rid].present?
      request = Accounting::VoucherRequest.find(params[:rid])
      @coop = request.payee

      @journal = Accounting::Journal.new(voucher: Accounting::Journal.generate_series, date_voucher: Date.today, global_payable: request&.requestable&.payable&.to_global_id, particulars: request&.requestable&.particulars)
    else
      @journal = Accounting::Journal.new(voucher: Accounting::Journal.generate_series, date_voucher: Date.today)
    end
  end

  # GET /accounting/journals/1/edit
  def edit
    string_voucher = @journal.voucher.to_s
  end

  # POST /accounting/journals
  def create
    @journal = Accounting::Journal.new(journal_params)
    @journal.employee = current_user.userable

    if @journal.save
      if params[:rid].present?
        request = Accounting::VoucherRequest.find(params[:rid])
        request.voucher_generated!
        @journal.update(voucher_request: request)
      end

      redirect_to @journal, notice: "Journal voucher created."
    else
      if params[:rid].present?
        request = Accounting::VoucherRequest.find(params[:rid])
        @amount = request.amount
        @coop = request.requestable.payable
      end

      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounting/journals/1
  def update
    @journal.update(journal_params)

    if @journal.save
      redirect_to @journal, notice: "Journal was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounting/journals/1
  def destroy
    @journal.destroy
    redirect_to accounting_journals_path, notice: "Journal was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_journal
    @journal = Accounting::Journal.find(params[:id])
  end

  def set_payables
    @payables = (Cooperative.all + Payee.all).sort_by(&:name)
  end

  # Only allow a list of trusted parameters through.
  def journal_params
    params.require(:accounting_journal).permit(:date_voucher, :voucher, :global_payable, :particulars, :amount, :branch_id)
  end
end
