class Treasury::PaymentsController < ApplicationController
  before_action :set_treasury_payment, only: %i[ show edit update destroy ]

  # GET /treasury/payments
  def index
    @treasury_payments = Treasury::Payment.all
  end

  # GET /treasury/payments/1
  def show
  end

  # GET /treasury/payments/new
  def new
    @treasury_payment = Treasury::Payment.new
  end

  # GET /treasury/payments/1/edit
  def edit
  end

  # POST /treasury/payments
  def create
    @treasury_payment = Treasury::Payment.new(treasury_payment_params)

    if @treasury_payment.save
      redirect_to @treasury_payment, notice: "Payment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /treasury/payments/1
  def update
    if @treasury_payment.update(treasury_payment_params)
      redirect_to @treasury_payment, notice: "Payment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /treasury/payments/1
  def destroy
    @treasury_payment.destroy
    redirect_to treasury_payments_url, notice: "Payment was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_treasury_payment
      @treasury_payment = Treasury::Payment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def treasury_payment_params
      params.require(:treasury_payment).permit(:payment_type, :check_no, :account_id, :amount, :cashier_entry_id)
    end
end
