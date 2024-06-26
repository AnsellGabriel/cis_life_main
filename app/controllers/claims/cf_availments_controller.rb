class Claims::CfAvailmentsController < ApplicationController
  before_action :set_cf_availment, only: %i[ show edit update destroy update_status ]

  # GET /cf_availments
  def index
    @cf_availments = Claims::CfAvailment.all
  end

  # GET /cf_availments/1
  def show
  end

  # GET /cf_availments/new
  def new
    @process_claim = Claims::ProcessClaim.find(params[:pc])
    amount = params[:a].to_d
    # raise "errors"
    @cf_availment = @process_claim.cf_availments.build
    @cf_availment.cf_account = Claims::CfAccount.find_by(cooperative: @process_claim.cooperative)
    @cf_availment.amount = amount
    @cf_availment.transaction_date = Date.today
    # @cf_availment = Claims::CfAvailment.new
  end

  # GET /cf_availments/1/edit
  def edit
  end

  # POST /cf_availments
  def create
    # raise "errors"
    @cf_availment = Claims::CfAvailment.new(cf_availment_params)
    @cf_availment.status = :pending
    @cf_availment.user = current_user
  
    if @cf_availment.save!
      redirect_to claim_process_claims_process_claim_path(@cf_availment.process_claim), notice: "Claims Fund successfully requested."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cf_availments/1
  def update
    if @cf_availment.update(cf_availment_params)
      redirect_to claims_cf_availments_path, notice: "Claims Fund successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    update_notice = ""
    @cf_account = @cf_availment.cf_account
    case params[:s].to_i
    when 1
        @cf_availment.update!(status: :approved)
        @cf_availment.cf_ledgers.create(cf_account: @cf_account, amount: @cf_availment.amount, entry_type: :credit, transaction_date: Time.now)
        if @cf_account.get_balance(Time.now) < @cf_account.amount_limit
          @cf_account.update(status: :critical)
        else 
          @cf_account.update(status: :active)
        end
        update_notice = "Claims Fund Approved"
      when 2
        @cf_availment.update!(status: :denied)
        update_notice = "Claims Fund Denied"
      when 0
        @cf_availment.update!(status: :pending)
        update_notice = "Claims Fund Pending"
    end
    
    redirect_to claims_cf_availments_path, notice: "Claims fund approved", status: :see_other
  end

  # DELETE /cf_availments/1
  def destroy
    @cf_availment.destroy
    redirect_to claims_cf_availments_path, notice: "Claims Fund successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cf_availment
      @cf_availment = Claims::CfAvailment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cf_availment_params
      params.require(:claims_cf_availment).permit(:process_claim_id, :cf_account_id, :user_id, :transaction_date, :amount, :description, :status)
    end
end
