class Treasury::CashierEntriesController < ApplicationController
  before_action :set_entry, only: %i[ show edit update cancel ]
  before_action :set_entriables, only: %i[ new create edit update]

  def download
    @receipt = Treasury::CashierEntry.find(params[:id])
    @entry = @receipt.entriable.instance_of?(Payment) ? @receipt.entriable.payable.agreement.cooperative : @receipt.entriable
    @amount_in_words = amount_to_words(@receipt.amount)
    @payment_type = @receipt.treasury_payment_type.name
    @vat = @receipt.vat

    respond_to do |format|
      format.pdf do
        render pdf: "OR##{@receipt.or_no}",
               page_size: "A4"
      end
    end
  end

  def print
    @receipt = Treasury::CashierEntry.find(params[:id])
    @entry = @receipt.entriable.instance_of?(Payment) ? @receipt.entriable.payable.agreement.cooperative : @receipt.entriable
    @amount_in_words = amount_to_words(@receipt.amount)
    @payment_type = @receipt.treasury_payment_type.name
    @vat = @receipt.vat
    # @positions = analyze_pdf("app/assets/pdfs/or_format.pdf", @receipt)

    respond_to do |format|
      format.pdf do
        render pdf: "OR##{@receipt.or_no}",
               page_size: "A4"
      end
    end
  end

  def index
    @entry = Treasury::CashierEntry.new

    # if params[:or_number].present?
    #   @entries = Treasury::CashierEntry.where(or_no: params[:or_number])
    # else
    #   @entries = Treasury::CashierEntry.all.order(created_at: :desc)
    # end

    @q = Treasury::CashierEntry.ransack(params[:q])
    @entries = @q.result.order(created_at: :desc)
    @entries = @entries.where(status: params[:status]) unless params[:status].nil?
    @entries = @entries.where(employee: params[:u]) unless params[:u].nil?

    if params[:date_from].present? && params[:date_to].present?
      @entries = @entries.where(created_at: params[:date_from].to_date.beginning_of_day..params[:date_to].to_date.end_of_day)
    end

    @pagy, @entries = pagy(@entries, items: 10)
  end

  def for_approval_index
    @entries = Treasury::CashierEntry.where(status: :for_approval).order(created_at: :desc)

    @pagy, @entries = pagy(@entries, items: 10)
  end

  def show
    @coop = @entry.entriable
    @ledgers = @entry.general_ledgers
    @bills = @entry.bills
  end

  def new
    last_series = Treasury::CashierEntry.all.present? ? Treasury::CashierEntry.last.or_no.to_i + 1 : 1
    @entry = Treasury::CashierEntry.new(or_no: last_series, or_date: Date.today)

    if params[:gr_id].present?
      @group_remit = GroupRemit.find(params[:gr_id])
      @entry.amount = @group_remit.coop_net_premium
      @entry.payment = Treasury::CashierEntry.payments[@group_remit.agreement.plan.acronym.downcase]
    end

  end

  def edit
  end

  def create
    @entry = Treasury::CashierEntry.new(entry_params.merge(employee: current_user.userable))
    @entry.branch = current_user.userable.branch_before_type_cast # assign employee branch to entry

    if @entry.entriable_type == "Remittance"
      @group_remit = @entry.entriable
    end

    @entry.check_agreement
    if @entry.save
      # if @entry.entriable_type == "Remittance"
      #   approve_payment(@group_remit.payments.last.id)
      # end

      redirect_to @entry, notice: "Entry added"
    else
      render :new, status: :unprocessable_entity
    end

  end

  # def autofill
  #   @entry.autofill(@entry.entriable)

  #   redirect_to payment_entry_path(params[:p_id], @entry), notice: "Ledger entries added!"
  # end

  def update
    @entry.check_agreement # check if the entry has a plan or agreement

    if @entry.update(entry_params)
      redirect_to @entry, notice: "Entry updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    if @entry.cancelled!
      redirect_to treasury_cashier_entry_path(@entry), notice: "OR cancelled"
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_entry
    @entry = Treasury::CashierEntry.find(params[:id])
  end

  def set_entriables
    @entriables = Cooperative.all.order(:name)
  end

  # Only allow a list of trusted parameters through.
  def entry_params
    params.require(:treasury_cashier_entry).permit(:deposit, :service_fee, :or_no, :or_date, :global_entriable, :treasury_payment_type_id, :treasury_account_id, :amount, :agreement_id, :plan_id, :agent_id)
  end

  def amount_to_words(amount)
    # Convert the integer part to words
    integer_part_words = amount.to_i.to_words

    # Convert the decimal part to words
    decimal_part = (amount.modulo(1) * 100).to_i

    # Format the result
    result = "#{integer_part_words.titleize} Pesos and #{decimal_part}/100 only"
  end

  def payment_type(type)
    case type
    when "lppi"
      "LOAN PAYMENT PROTECTION INSURANCE (LPPI)"
    when "gyrt"
      "GROUP YEARLY RENEWABLE TERM (GYRT)"
    else
      type.titleize
    end
  end

  # def analyze_pdf(pdf_path, receipt)
  #   # entry = receipt.entriable.instance_of?(Payment) ? receipt.entriable.payable.agreement.cooperative : receipt.entriable
  #   # amount_in_words = amount_to_words(receipt.amount)
  #   # payment_type = payment_type(receipt.payment_type)
  #   # vat = receipt.vat

  #   # pdf = PDF::Reader.new(pdf_path)
  #   # text = pdf.pages.first.text

  #   # replacements = {
  #   #   "March 01, 2024" => "#{receipt.or_date.strftime('%B %d, %Y')}",
  #   #   "CANLA-ON LOCAL GOVERNMENT UNIT" => "#{entry.name}",
  #   #   "CANLA-ON CITY, NEGROS OCCIDENTAL" => "#{entry.get_address}",
  #   #   "299,250.00" => "energetic"
  #   # }


  #   # PDF::Reader.open(pdf_path) do |reader|
  #   #   reader.pages.each do |page|
  #   #     page.text.each_line do |line|
  #   #       # Extract text, x-position, and y-position from each line
  #   #       text = line[:string]
  #   #       x_position = line[:x]
  #   #       y_position = line[:y]

  #   #       # Store text, x-position, and y-position in a hash
  #   #       positions << { text: text, x_position: x_position, y_position: y_position }
  #   #     end
  #   #   end
  #   # end


  #   positions
  # end
end
