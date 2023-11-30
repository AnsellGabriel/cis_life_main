class ClaimRequestForPaymentsController < ApplicationController
  before_action :set_claim_request_for_payment, only: %i[ show edit update destroy ]

  # GET /claim_request_for_payments
  def index
    @claim_request_for_payments = ClaimRequestForPayment.all
  end

  # GET /claim_request_for_payments/1
  def show
  end

  # GET /claim_request_for_payments/new
  def new
    @claim_request_for_payment = ClaimRequestForPayment.new
  end

  # GET /claim_request_for_payments/1/edit
  def edit
  end

  # POST /claim_request_for_payments
  def create
    @claim_request_for_payment = ClaimRequestForPayment.new(claim_request_for_payment_params)

    if @claim_request_for_payment.save
      redirect_to @claim_request_for_payment, notice: "Claim request for payment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /claim_request_for_payments/1
  def update
    if @claim_request_for_payment.update(claim_request_for_payment_params)
      redirect_to @claim_request_for_payment, notice: "Claim request for payment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /claim_request_for_payments/1
  def destroy
    @claim_request_for_payment.destroy
    redirect_to claim_request_for_payments_url, notice: "Claim request for payment was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_claim_request_for_payment
      @claim_request_for_payment = ClaimRequestForPayment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def claim_request_for_payment_params
      params.require(:claim_request_for_payment).permit(:process_claim_id, :amount, :status)
    end
end
