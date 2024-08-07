class Accounting::ChecksController < ApplicationController
  include Accounting::Filterable

  before_action :authenticate_user!
  before_action :set_check, only: %i[ show edit update destroy cancel check claimable download print]
  before_action :set_payables, only: %i[ new edit create update]

  def download
    @ledger_entries = @check.general_ledgers
    @accountant = @check.employee
    @approver = Employee.find(@check.approved_by) if @check.approved_by.present?
    @certifier = Employee.find(@check.certified_by) if @check.certified_by.present?
    @auditor = User.find(@check.audited_by) if @check.audited_by.present?
    @amount_in_words = amount_to_words(@check.amount)

    respond_to do |format|
      format.pdf do
        render pdf: "Check voucher ##{@check.voucher}",
               page_size: "A4"
      end
    end
  end

  def print
    @ledger_entries = @check.general_ledgers
    @accountant = @check.employee
    @approver = Employee.find(@check.approved_by) if @check.approved_by.present?
    @certifier = Employee.find(@check.certified_by) if @check.certified_by.present?
    @auditor = User.find(@check.audited_by) if @check.audited_by.present?
    @amount_in_words = amount_to_words(@check.amount)

    respond_to do |format|
      format.pdf do
        render pdf: "Check voucher ##{@check.voucher}",
               page_size: "A4"
      end
    end
  end

  # def requests
  #   @claim_requests = Accounting::CheckVoucherRequest.all.order(created_at: :desc)
  #   @pagy, @claim_requests = pagy(@claim_requests, items: 10)
  # end

  def claimable
    total_business_checks = @check.business_checks.sum(:amount)

    if @check.amount != total_business_checks
      return redirect_to accounting_check_path(@check), alert: "Total amount of business checks is not equal to the voucher amount"
    end

    requestable = @check.voucher_request.requestable

    ActiveRecord::Base.transaction do
      @check.update!(claimable: true)

      if requestable.is_a?(Claims::ProcessClaim)
        requestable.update!(claim_route: 12, payment: 1)
        coop = requestable.coop_member.cooperative
        Notification.create(notifiable: coop, message: "Claim for #{requestable.coop_member.full_name} is claimable")
      elsif requestable.is_a?(ProcessCoverage)
        requestable.group_remit.ready_for_refund!
      end
    end

    redirect_to accounting_check_path(@check), notice: "Checks ready for claim"
  end

  def for_approval_index
    @checks = Accounting::Check.where(status: :for_approval).order(created_at: :desc)

    @pagy, @checks = pagy(@checks, items: 10)
  end

  # GET /accounting/checks
  def index
    if params[:e].present?
      @checks = Accounting::Check.where(employee: params[:e])
    else
      @checks = Accounting::Check.all
    end

    @q = @checks.ransack(params[:q])

    filtered_and_paginated_vouchers # concerns/accounting/filterable.rb
  end

  # GET /accounting/checks/1
  def show
    @business_checks = @check.business_checks.where.not(id: nil).order(created_at: :desc)
    @ledgers = @check.general_ledgers

    if @check.voucher_request.present?
      @request = @check.voucher_request
      @claim = @request.requestable
    end
  end

  # GET /accounting/checks/new
  def new
    last_voucher = Accounting::Check.pluck(:voucher).last.gsub('CV', '').to_i
    initiate_voucher = last_voucher ? last_voucher + 1 : 1

    if params[:rid].present?
      request = Accounting::VoucherRequest.find(params[:rid])
      @amount = request.amount
      @coop = request.requestable.cooperative
      @check = Accounting::Check.new(voucher: sprintf("%05d", initiate_voucher), payable: @coop, amount: @amount, date_voucher: Date.today, particulars: request.particulars)
    else
      @check = Accounting::Check.new(voucher: sprintf("%05d", initiate_voucher), date_voucher: Date.today)
    end
  end

  # GET /accounting/checks/1/edit
  def edit

  end

  # POST /accounting/checks
  def create
    @check = Accounting::Check.new(check_params)
    @check.employee = current_user.userable
    @check.branch = current_user.userable.branch

    if @check.save
      if params[:rid].present?
        request = Accounting::VoucherRequest.find(params[:rid])
        request.voucher_generated!
        @check.update(voucher_request: request)
      end

      redirect_to @check, notice: "Check voucher created."
    else
      if params[:rid].present?
        request = Accounting::VoucherRequest.find(params[:rid])
        @amount = request.amount
        @coop = request.requestable.cooperative
      end

      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounting/checks/1
  def update
    if @check.update!(check_params)
      redirect_to @check, notice: "Check voucher updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounting/checks/1
  def destroy
    @check.destroy
    redirect_to accounting_checks_path, notice: "Check voucher deleted.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_check
    @check = Accounting::Check.find(params[:id])
  end

  # collection of payees
  def set_payables
    @payables = (Cooperative.all.select(:id, :name) + Payee.all.select(:id, :name)).sort_by(&:name)
  end

  # Only allow a list of trusted parameters through.
  def check_params
    params.require(:accounting_check).permit(:date_voucher, :voucher, :global_payable, :particulars, :treasury_account_id, :amount, :payable_id)
  end

  # convert the string amount to float
  # def modified_check_params
  #   check_params[:amount] = check_params[:amount].to_f
  #   check_params
  # end

  def amount_to_words(amount)
    # Convert the integer part to words
    integer_part_words = amount.to_i.to_words

    # Convert the decimal part to words
    decimal_part = (amount.modulo(1) * 100).to_i

    # Format the result
    result = "#{integer_part_words.titleize} Pesos and #{decimal_part}/100 only"
  end
end
