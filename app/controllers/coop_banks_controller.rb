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
    @coop = Cooperative.find(params[:cooperative_id])
    @bank = @coop.coop_banks.new
  end

  # GET /coop_banks/1/edit
  def edit

  end

  # POST /coop_banks
  def create
    @coop = Cooperative.find(params[:cooperative_id])
    @bank = @coop.coop_banks.build(coop_bank_params)

    if @bank.save
        redirect_to approve_claim_debit_claims_process_claim_path(params[:pc_id]), notice: "Bank successfully added"
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
      params.require(:coop_bank).permit(:name, :account_number, :branch)
    end
end
