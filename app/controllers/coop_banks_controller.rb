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
    @account = Treasury::Account.new
  end

  # GET /coop_banks/1/edit
  def edit

  end

  # POST /coop_banks
  def create
    @coop = Cooperative.find(params[:cooperative_id])
    @account = Treasury::Account.bank.find_or_initialize_by(account_number: coop_bank_params[:account_number])

    ActiveRecord::Base.transaction do
      if @account.new_record?
        @account.add_bank(coop_bank_params[:name], coop_bank_params[:address])
      end

      if @account.save
        begin
          @coop_bank = CoopBank.create!(cooperative: @coop, treasury_account: @account)

          redirect_to approve_claim_debit_claims_process_claim_path(params[:pc_id]), notice: "Bank successfully added"
        rescue ActiveRecord::RecordInvalid => e
          redirect_to approve_claim_debit_claims_process_claim_path(params[:pc_id])
        end
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
