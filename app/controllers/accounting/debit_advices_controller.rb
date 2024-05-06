class Accounting::DebitAdvicesController < ApplicationController
  before_action :set_debit_advice, only: %i[ show edit update destroy ]
  before_action :set_payables, only: %i[ new edit create update]

  # GET /accounting/debit_advices
  def index
    @debit_advices = Accounting::DebitAdvice.all.order(created_at: :desc)
    @q = @debit_advices.ransack(params[:q])
    @debit_advices = @q.result

    @pagy, @debit_advices = pagy(@debit_advices, items: 10)
  end

  # GET /accounting/debit_advices/1
  def show
    @ledgers = @debit_advice.general_ledgers
    @bank = @debit_advice.treasury_account

    if @debit_advice.check_voucher_request.present?
      @request = @debit_advice.check_voucher_request
      @claim = @request.requestable
    end
  end

  # GET /accounting/debit_advices/new
  def new
    if params[:rid].present?
      @claim_request = Accounting::CheckVoucherRequest.find(params[:rid])
      @amount = @claim_request.amount
      @bank = Treasury::Account.find(@claim_request.bank_id)
      @coop = @claim_request.requestable.cooperative
      @debit_advice = Accounting::DebitAdvice.new(voucher: Accounting::DebitAdvice.generate_series, payable: @coop, amount: @amount, date_voucher: Date.today, particulars: "#{@claim_request.description} \n\nBank: #{@bank.name}\nAccount Number: #{@bank.account_number}\nAddress: #{@bank.address}")
    else
      @debit_advice = Accounting::DebitAdvice.new(voucher: Accounting::DebitAdvice.generate_series, date_voucher: Date.today)
    end
  end

  # GET /accounting/debit_advices/1/edit
  def edit
  end

  # POST /accounting/debit_advices
  def create
    @debit_advice = Accounting::DebitAdvice.new(modified_da_params)
    @debit_advice.accountant_id = current_user.userable.id
    @debit_advice.branch = current_user.userable.branch_before_type_cast

    if @debit_advice.save
      if params[:rid].present?
        @claim_request = Accounting::CheckVoucherRequest.find(params[:rid])
        @claim_request.voucher_generated!
        @debit_advice.update(check_voucher_request: @claim_request)
      end

      redirect_to @debit_advice, notice: "Debit advice created."
    else
      if params[:rid].present?
        @claim_request = Accounting::CheckVoucherRequest.find(params[:rid])
        @bank = Treasury::Account.find(@claim_request.bank_id)
        @amount = @claim_request.amount
        @coop = @claim_request.requestable.cooperative
      end

      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounting/debit_advices/1
  def update
    if @debit_advice.update(modified_da_params)
      redirect_to @debit_advice, notice: "Debit advice updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounting/debit_advices/1
  def destroy
    @accounting_debit_advice.destroy
    redirect_to accounting_debit_advices_url, notice: "Debit advice was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_debit_advice
    @debit_advice = Accounting::DebitAdvice.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def da_params
    params.require(:accounting_debit_advice).permit(:treasury_account, :date_voucher, :voucher, :global_payable, :particulars, :treasury_account_id, :amount, :payable_id)
  end

  def modified_da_params
    da_params[:amount] = da_params[:amount].to_f
    da_params
  end

  # collection of payees
  def set_payables
    @payables = (Cooperative.all + Payee.all).sort_by(&:name)
  end
end
