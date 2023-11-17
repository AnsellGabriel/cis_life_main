class GeneralLedgersController < ApplicationController
  include Treasuries::Path

  before_action :set_entry_and_ledgers, only: %i[new create destroy edit update post]

  def post
    if (@ledgers.total_debit != @ledgers.total_credit) || @ledgers.empty?
      return redirect_to entry_path, alert: "Unable to post ledger, #{@ledgers.empty? ? 'no entry.' : 'credit and debit total not equal.'}"
    end

    if @entry.update(status: :posted)
      if params[:e_t] == 'ce' && @entry.remittance?
        @entry.entriable.paid
      end

      redirect_to entry_path, notice: "#{params[:e_t] == 'ce' ? 'OR' : 'Voucher'} posted"
    end
  end

  def index
    @general_ledgers = GeneralLedger.all
  end

  def show
  end

  # GET /entries/:entry_id/ledger/new
  def new
    @ledger = @ledgers.new
  end

  def edit
    @ledger = @ledgers.find(params[:id])
  end

  def create
    @ledger = @ledgers.new(general_ledger_params)

    if @ledger.save
      redirect_to entry_path, notice: "Entry added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @ledger = @ledgers.find(params[:id])

    if @ledger.update(general_ledger_params)
        redirect_to entry_path, notice: "Entry updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ledger = @ledgers.find(params[:id])

    if @ledger.destroy
      redirect_to entry_path, alert: "Entry deleted.", status: :see_other
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry_and_ledgers
      case params[:e_t]
      when 'ce' then klass = Treasury::CashierEntry
      when 'cv' then klass = Accounting::Check
      end

      @entry = klass.find(params[:entry_id])
      @ledgers = @entry.general_ledgers
    end

    # Only allow a list of trusted parameters through.
    def general_ledger_params
      params.require(:general_ledger).permit(:description, :account_id, :amount, :ledger_type)
    end

end
