class CoopBanksController < ApplicationController
  before_action :set_coop_bank, only: %i[ show edit update destroy ]

  # GET /coop_banks
  def index
    @coop_banks = CoopBank.all
  end

  # GET /coop_banks/1
  def show
  end

  # GET /coop_banks/new
  def new
    @coop = Cooperative.find(params[:p])
    @coop_bank = CoopBank.new()
    @coop_bank.cooperative = @coop
  end

  # GET /coop_banks/1/edit
  def edit

  end

  # POST /coop_banks
  def create
    @coop_bank = CoopBank.new(coop_bank_params)
    # raise "errors"
    if @coop_bank.save!
      return redirect_to member_url(@member), notice: "Bank account was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /coop_banks/1
  def update
    if @coop_bank.update(coop_bank_params)
      redirect_to @coop_bank, notice: "Coop bank was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /coop_banks/1
  def destroy
    @coop_bank.destroy
    redirect_to coop_banks_url, notice: "Coop bank was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coop_bank
      @coop_bank = CoopBank.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def coop_bank_params
      params.require(:coop_bank).permit(:name, :account_number, :branch, :bank_id, :cooperative_id)
    end
end
