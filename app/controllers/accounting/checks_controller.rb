class Accounting::ChecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_check, only: %i[ show edit update destroy cancel check claimable download print]
  before_action :set_payables, only: %i[ new edit create update]

  def download
    @ledger_entries = @check.general_ledgers
    @accountant = Employee.find(@check.accountant_id)
    @approver = Employee.find(@check.approved_by) if @check.approved_by.present?
    @certifier = Employee.find(@check.certified_by) if @check.certified_by.present?
    @auditor = Employee.find(@check.audited_by) if @check.audited_by.present?
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
    @accountant = Employee.find(@check.accountant_id)
    @approver = Employee.find(@check.approved_by) if @check.approved_by.present?
    @certifier = Employee.find(@check.certified_by) if @check.certified_by.present?
    @auditor = Employee.find(@check.audited_by) if @check.audited_by.present?
    @amount_in_words = amount_to_words(@check.amount)

    respond_to do |format|
      format.pdf do
        render pdf: "Check voucher ##{@check.voucher}",
               page_size: "A4"
      end
    end
  end

  def requests
    @claim_requests = Accounting::CheckVoucherRequest.all.order(created_at: :desc)
    @pagy, @claim_requests = pagy(@claim_requests, items: 10)
  end

  def claimable
    total_business_checks = @check.business_checks.sum(:amount)

    if @check.amount != total_business_checks
      return redirect_to accounting_check_path(@check), alert: "Total amount of business checks is not equal to the voucher amount"
    end

    claim = @check.check_voucher_request.requestable

    ActiveRecord::Base.transaction do
      @check.update!(claimable: true)

      if claim.is_a?(ProcessClaim)
        claim.update!(claim_route: 12, payment: 1)
      elsif claim.is_a?(ProcessCoverage)
        claim.group_remit.ready_for_refund!
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
    if params[:check_number].present?
      @checks = Accounting::Check.where(voucher: params[:check_number]).order(created_at: :desc)
    else
      @checks = Accounting::Check.all.order(created_at: :desc)
    end

    @pagy, @checks = pagy(@checks, items: 10)
  end

  # GET /accounting/checks/1
  def show
    @business_checks = @check.business_checks.where.not(id: nil).order(created_at: :desc)
    @ledgers = @check.general_ledgers
    @claim = @check.check_voucher_request.requestable if @check.check_voucher_request.present?
  end

  # GET /accounting/checks/new
  def new
    last_voucher = Accounting::Check.maximum(:voucher)
    initiate_voucher = last_voucher ? last_voucher + 1 : 1

    if params[:rid].present?
      claim_request = Accounting::CheckVoucherRequest.find(params[:rid])
      amount = claim_request.amount
      coop = claim_request.requestable.cooperative

      @check = Accounting::Check.new(voucher: initiate_voucher, payable: coop, amount: amount, date_voucher: Date.today)
    else
      @check = Accounting::Check.new(voucher: initiate_voucher, date_voucher: Date.today)
    end

  end

  # GET /accounting/checks/1/edit
  def edit

  end

  # POST /accounting/checks
  def create
    @check = Accounting::Check.new(modified_check_params)
    @check.accountant_id = current_user.id

    if @check.save
      if params[:rid].present?
        claim_request = Accounting::CheckVoucherRequest.find(params[:rid])
        claim_request.voucher_generated!
        @check.update(check_voucher_request: claim_request)
      end

      redirect_to @check, notice: "Check voucher created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounting/checks/1
  def update
    if @check.update(modified_check_params)
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

  # def cancel
  #   @check.transaction do
  #     @check.cancelled!
  #     @check.check_voucher_request.pending! if @check.check_voucher_request.present?
  #   end

  #   redirect_to @check, alert: "Voucher cancelled."
  # end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_check
    @check = Accounting::Check.find(params[:id])
  end

  # collection of payees
  def set_payables
    @payables = (Cooperative.all + Payee.all).sort_by(&:name)
  end

  # Only allow a list of trusted parameters through.
  def check_params
    params.require(:accounting_check).permit(:date_voucher, :voucher, :global_payable, :particulars, :treasury_account_id, :amount)
  end

  # convert the string amount to float
  def modified_check_params
    check_params[:amount] = check_params[:amount].to_f
    check_params
  end

  def amount_to_words(amount)
    # Convert the integer part to words
    integer_part_words = amount.to_i.to_words

    # Convert the decimal part to words
    decimal_part = (amount.modulo(1) * 100).to_i

    # Format the result
    result = "#{integer_part_words.titleize} Pesos and #{decimal_part}/100 only"
  end

end
