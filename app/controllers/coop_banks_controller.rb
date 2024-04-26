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
    @coop_bank = Treasury::Account.new
  end

  # GET /coop_banks/1/edit
  def edit
    
  end

  # POST /coop_banks
  def create
    @coop = Cooperative.find(params[:cooperative_id])
    @coop_bank = Treasury::Account.bank.find_or_initialize_by(name: coop_bank_params[:name], account_number: coop_bank_params[:account_number])

    ActiveRecord::Base.transaction do
      if @coop_bank.new_record?
        @coop_bank.address = coop_bank_params[:address]
        @coop_bank.account_type = :assets
        @coop_bank.account_category = :bank
      end

      if @coop_bank.save
        @coop.treasury_accounts << @coop_bank

        redirect_to approve_claim_debit_process_claim_path(params[:pc_id]), notice: "Bank successfully added"
      else
        render :new, status: :unprocessable_entity
      end
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
      params.require(:treasury_account).permit(:name, :account_number, :address)
    end
end
