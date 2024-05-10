class Accounting::DebitAdvicesController < ApplicationController
  before_action :set_debit_advice, only: %i[ show edit update destroy new_receipt upload_receipt]
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
    @request = @debit_advice.voucher_request

    if @request.requestable.present? && @request.requestable.is_a?(Claims::ProcessClaim)
      @claim = @request.requestable
      @claim_type_documents = Claims::ClaimTypeDocument.where(claim_type: @request.requestable.claim_type)
    end
  end

  # GET /accounting/debit_advices/new
  def new
    if params[:rid].present?
      @request = Accounting::VoucherRequest.find(params[:rid])
      @bank = @request.account
      @coop = @request.requestable.payable
      @debit_advice = Accounting::DebitAdvice.new(voucher: Accounting::DebitAdvice.generate_series, payable: @coop, amount: @request.amount, date_voucher: Date.today, particulars: "#{@request.particulars} \n\nBank: #{@bank.name}\nAccount Number: #{@bank.account_number}\nAddress: #{@bank.address}")
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

    ActiveRecord::Base.transaction do
      if @debit_advice.save
        if params[:rid].present?
          @request = Accounting::VoucherRequest.find(params[:rid])
          @request.voucher_generated!
          @debit_advice.update(voucher_request: @request)
        end

        redirect_to @debit_advice, notice: "Debit advice created."
      else
        if params[:rid].present?
          @request = Accounting::VoucherRequest.find(params[:rid])
          @bank = @request.account
          @amount = @request.amount
          @coop = @request.requestable.cooperative
        end

        render :new, status: :unprocessable_entity
      end
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

  def new_receipt
  end

  def upload_receipt
    file = params[:file]

    if file.nil?
      redirect_to accounting_debit_advice_path(@debit_advice), alert: 'Unable to upload an empty file'
      return
    end

    @debit_advice.attachment ||= @debit_advice.build_attachment
    @debit_advice.attachment.receipt = file

    if @debit_advice.attachment.save
      redirect_to accounting_debit_advice_path(@debit_advice), notice: 'File uploaded'
    else
      redirect_to accounting_debit_advice_path(@debit_advice), alert: 'Failed to upload file'
    end
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
