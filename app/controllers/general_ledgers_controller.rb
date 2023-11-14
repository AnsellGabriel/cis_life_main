class GeneralLedgersController < ApplicationController
  before_action :set_general_ledger, only: %i[ show edit update destroy ]

  # GET /general_ledgers
  def index
    @general_ledgers = GeneralLedger.all
  end

  # GET /general_ledgers/1
  def show
  end

  # GET /general_ledgers/new
  def new
    @general_ledger = GeneralLedger.new
  end

  # GET /general_ledgers/1/edit
  def edit
  end

  # POST /general_ledgers
  def create
    @general_ledger = GeneralLedger.new(general_ledger_params)

    if @general_ledger.save
      redirect_to @general_ledger, notice: "General ledger was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /general_ledgers/1
  def update
    if @general_ledger.update(general_ledger_params)
      redirect_to @general_ledger, notice: "General ledger was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /general_ledgers/1
  def destroy
    @general_ledger.destroy
    redirect_to general_ledgers_url, notice: "General ledger was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_general_ledger
      @general_ledger = GeneralLedger.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def general_ledger_params
      params.require(:general_ledger).permit(:ledgerable_id, :ledgerable_type, :description, :debit, :credit)
    end
end
