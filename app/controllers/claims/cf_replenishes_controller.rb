class Claims::CfReplenishesController < ApplicationController
  before_action :set_cf_replenish, only: %i[ show edit update destroy update_status ]
  # before_action :set_cf_availment, only: %i[  ]

  # GET /cf_replenishes
  def index
    @cf_replenishes = Claims::CfReplenish.all
  end

  # GET /cf_replenishes/1
  def show
  end

  # GET /cf_replenishes/new
  def new
    # raise "errors"
    @cf_account = Claims::CfAccount.find(params[:cf])
    @cf_replenish = Claims::CfReplenish.new
    @cf_replenish.cf_account = @cf_account
    @cf_replenish.transaction_date = Date.today 
    @cf_replenish.amount = @cf_account.amount - @cf_account.get_balance(Time.now)
  end

  # def new_availment 
  #   @cf_availment = Claims::CfAvailment.new
  # end

  # GET /cf_replenishes/1/edit
  def edit
  end

  # POST /cf_replenishes
  def create
    @cf_replenish = Claims::CfReplenish.new(cf_replenish_params)

    @cf_replenish.status = :pending
    @cf_replenish.user = current_user
    if @cf_replenish.save
      redirect_to claims_cf_replenishes_path, notice: "Claims fund replenish was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cf_replenishes/1
  def update
    if @cf_replenish.update(cf_replenish_params)
      redirect_to claims_cf_replenishes_path, notice: "Claims fund replenish was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    update_notice = ""
    @cf_account = @cf_replenish.cf_account
    case params[:s].to_i
    when 1
        @cf_replenish.update!(status: :approved_head)
        @cf_replenish.cf_ledgers.create(cf_account: @cf_account, amount: @cf_replenish.amount, entry_type: :debit, transaction_date: Time.now)
        if @cf_account.get_balance(Time.now) < @cf_account.amount_limit
          @cf_account.update(status: :critical)
        else 
          @cf_account.update(status: :active)
        end
        update_notice = "Claims Fund Approved"
      when 2
        @cf_replenish.update!(status: :denied)
        update_notice = "Claims Fund Denied"
      when 0
        @cf_replenish.update!(status: :pending)
        update_notice = "Claims Fund Pending"
      when 3
        @cf_replenish.update!(status: :approved_final)
        
        update_notice = "Claims Fund Approved Final"
    end
    
    redirect_to claims_cf_replenishes_path, notice: "Claims fund approved", status: :see_other
  end

  # DELETE /cf_replenishes/1
  def destroy
    @cf_replenish.destroy
    redirect_to cf_replenishes_url, notice: "Cf replenish was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cf_replenish
      @cf_replenish = Claims::CfReplenish.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cf_replenish_params
      params.require(:claims_cf_replenish).permit(:cf_account_id, :user_id, :transaction_date, :amount, :description, :status, :orno, :ordate)
    end

    # def cf_availment_params
    #   params.require(:claims_cf_availment).permit(:process_claim_id, :cf_account_id, :user_id, :transaction_date, :amount, :description, :status)
    # end

end
