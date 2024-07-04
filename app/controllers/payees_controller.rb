class PayeesController < ApplicationController
  before_action :set_payee, only: %i[ show edit update destroy ]

  # GET /payees
  def index
    @q = Payee.ransack(params[:q])
    @payees = @q.result(distinct: true)
    @pagy, @payees = pagy(@payees, items: 10)
  end

  # GET /payees/1
  def show
  end

  # GET /payees/new
  def new
    @payee = Payee.new
  end

  # GET /payees/1/edit
  def edit
  end

  # POST /payees
  def create
    @payee = Payee.new(payee_params)

    if @payee.save
      redirect_to @payee, notice: "Payee was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payees/1
  def update
    if @payee.update(payee_params)
      redirect_to @payee, notice: "Payee was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /payees/1
  def destroy
    @payee.destroy
    redirect_to payees_url, notice: "Payee was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payee
      @payee = Payee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payee_params
      params.require(:payee).permit(:name, :address, :contact_number, :payee_type, :cooperative_id)
    end
end
