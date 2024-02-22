class GeneralLedgersController < ApplicationController
  include Treasuries::Path

  before_action :set_entry_and_ledgers, only: %i[new create destroy edit update post autofill]

  def post
    if (@ledgers.total_debit != @ledgers.total_credit) || @ledgers.empty?
      return redirect_to entry_path, alert: "Unable to post ledger, #{@ledgers.empty? ? 'no entry.' : 'credit and debit total not equal.'}"
    end

    if (@ledgers.total_debit != @entry.total_amount) || (@ledgers.total_credit != @entry.total_amount)
      return redirect_to entry_path, alert: "Unable to post ledger, credit and debit total not equal to total amount"
    end

    if @entry.update(status: :posted)
      # params[:e_t] = entry type
      if params[:e_t] == 'ce' && @entry.remittance?
        pay_service = PaymentService.new(@entry.entriable, current_user, @entry)
        result = pay_service.post_payment
      elsif params[:e_t] == 'cv'
        @entry.update(status: :posted, post_date: Date.current)
        claim_track = @entry.check_voucher_request.requestable.process_track.build
        claim_track.route_id = 14
        claim_track.user_id = current_user.id
        claim_track.save
        result = 'Voucher posted.'
      end

      redirect_to entry_path, notice: result
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

  def autofill
    GeneralLedger.autofill(params[:e_t], @entry)

    redirect_to entry_path, notice: "Ledger entries autofilled."
  end

  def update
    @ledger = @ledgers.find(params[:id])

    if @ledger.update(general_ledger_params)
      edirect_to entry_path, notice: "Entry updated."
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
