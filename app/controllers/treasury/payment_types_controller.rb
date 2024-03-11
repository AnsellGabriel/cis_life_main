class Treasury::PaymentTypesController < ApplicationController
  before_action :set_treasury_payment_type, only: %i[ show edit update destroy ]

  # GET /treasury/payment_types
  def index
    @q = Treasury::PaymentType.ransack(params[:q])
    @treasury_payment_types = @q.result(distinct: true)

    @pagy, @treasury_payment_types = pagy(@treasury_payment_types, items: 10)
  end

  # GET /treasury/payment_types/1
  def show
  end

  # GET /treasury/payment_types/new
  def new
    @treasury_payment_type = Treasury::PaymentType.new
  end

  # GET /treasury/payment_types/1/edit
  def edit
  end

  # POST /treasury/payment_types
  def create
    @treasury_payment_type = Treasury::PaymentType.new(treasury_payment_type_params)

    if @treasury_payment_type.save
      redirect_to treasury_payment_types_path, notice: "Payment type was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /treasury/payment_types/1
  def update
    if @treasury_payment_type.update(treasury_payment_type_params)
      redirect_to treasury_payment_types_path, notice: "Payment type was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /treasury/payment_types/1
  def destroy
    @treasury_payment_type.destroy
    redirect_to treasury_payment_types_url, notice: "Payment type was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_treasury_payment_type
      @treasury_payment_type = Treasury::PaymentType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def treasury_payment_type_params
      params.require(:treasury_payment_type).permit(:name)
    end
end
