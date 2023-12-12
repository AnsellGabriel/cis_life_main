class ClaimPaymentsController < ApplicationController
  before_action :set_claim_payment, only: %i[ show edit update destroy ]

  # GET /claim_payments
  def index
    @claim_payments = ClaimPayment.all
  end

  # GET /claim_payments/1
  def show
  end

  # GET /claim_payments/new
  def new
    @claim_payment = ClaimPayment.new
  end

  # GET /claim_payments/1/edit
  def edit
  end

  # POST /claim_payments
  def create
    @claim_payment = ClaimPayment.new(claim_payment_params)

    if @claim_payment.save
      redirect_to @claim_payment, notice: "Claim payment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /claim_payments/1
  def update
    if @claim_payment.update(claim_payment_params)
      redirect_to @claim_payment, notice: "Claim payment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /claim_payments/1
  def destroy
    @claim_payment.destroy
    redirect_to claim_payments_url, notice: "Claim payment was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_claim_payment
      @claim_payment = ClaimPayment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def claim_payment_params
      params.require(:claim_payment).permit(:beneficiary, :amount, :process_claim_id)
    end
end
