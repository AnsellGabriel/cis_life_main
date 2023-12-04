class Accounting::ChecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_check, only: %i[ show edit update destroy cancel]
  before_action :set_payables, only: %i[ new edit create update]

  def requests
    @claim_requests = ClaimRequestForPayment.all
    @pagy, @claim_requests = pagy(@claim_requests, items: 10)
  end

  # GET /accounting/checks
  def index
    if params[:check_number].present?
      @checks = Accounting::Check.where(voucher: params[:check_number])
    else
      @checks = Accounting::Check.all
    end

    @pagy, @checks = pagy(@checks, items: 10)
  end

  # GET /accounting/checks/1
  def show
    @business_checks = @check.business_checks.where.not(id: nil).order(created_at: :desc)
    @ledgers = @check.general_ledgers
    @claim = @check.claim_request_for_payment.process_claim if @check.claim_request_for_payment.present?
  end

  # GET /accounting/checks/new
  def new
    last_voucher = Accounting::Check.maximum(:voucher)
    initiate_voucher = last_voucher ? last_voucher + 1 : 1

    if params[:rid].present?
      claim_request = ClaimRequestForPayment.find(params[:rid])
      amount = claim_request.amount
      coop = claim_request.process_claim.cooperative

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

    if @check.save
      if params[:rid].present?
        claim_request = ClaimRequestForPayment.find(params[:rid])
        claim_request.voucher_generated!
        @check.update(claim_request_for_payment: claim_request)
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

  def cancel
    @check.transaction do
      @check.cancelled!
      @check.claim_request_for_payment.pending! if @check.claim_request_for_payment.present?
    end

    redirect_to @check, alert: "Voucher cancelled."
  end

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

end
