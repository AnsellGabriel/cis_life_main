class Accounting::JournalsController < ApplicationController
  before_action :set_journal, only: %i[ show edit update destroy download]
  before_action :set_payables, only: %i[ new edit create update]

  def download
    @ledger_entries = @journal.general_ledgers
    @accountant = Employee.find(@journal.accountant_id)
    @approver = Employee.find(@journal.approved_by) if @journal.approved_by.present?
    @certifier = Employee.find(@journal.certified_by) if @journal.certified_by.present?

    respond_to do |format|
      format.pdf do
        render pdf: "Check voucher ##{@journal.voucher}",
               page_size: "A4"
      end
    end
  end

  def for_approval_index
    @journals = Accounting::Journal.where(status: :for_approval).order(created_at: :desc)

    @pagy, @journals = pagy(@journals, items: 10)
  end

  # GET /accounting/journals
  def index
    # byebug

    if params[:voucher_yr].present? || params[:voucher_month].present? || params[:voucher_series].present?
      @journals = Accounting::Journal.where(type: "Accounting::Journal").where("voucher like ?", "%#{params[:voucher_yr] + params[:voucher_month] + params[:voucher_series]}%")
    else
      @journals = Accounting::Journal.all
    end

    @pagy, @journals = pagy(@journals, items: 10)
  end

  # GET /accounting/journals/1
  def show
    @ledgers = @journal.general_ledgers
  end

  # GET /accounting/journals/new
  def new
    last_voucher = Accounting::Journal.maximum(:voucher)
    initiate_voucher = last_voucher.to_i ? last_voucher.to_i + 1 : 0

    @journal = Accounting::Journal.new(voucher: initiate_voucher)
  end

  # GET /accounting/journals/1/edit
  def edit
    string_voucher = @journal.voucher.to_s
    @journal.voucher_year = string_voucher[0..2]
    @journal.voucher_month = string_voucher[3..4]
    @journal.voucher_series = string_voucher[5..7]
  end

  # POST /accounting/journals
  def create
    @journal = Accounting::Journal.new(journal_params)
    @journal.voucher = voucher_series
    @journal.accountant_id = current_user.userable.id
    @journal.branch = current_user.userable.branch_before_type_cast

    if @journal.save
      redirect_to @journal, notice: "Journal was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounting/journals/1
  def update
    @journal.update(journal_params)
    @journal.voucher = voucher_series

    if @journal.save
      redirect_to @journal, notice: "Journal was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounting/journals/1
  def destroy
    @journal.destroy
    redirect_to accounting_journals_path, notice: "Journal was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_journal
    @journal = Accounting::Journal.find(params[:id])
  end

  def set_payables
    @payables = Cooperative.all.order(:name)
  end

  # Only allow a list of trusted parameters through.
  def journal_params
    params.require(:accounting_journal).permit(:date_voucher, :voucher_year, :voucher_month, :voucher_series, :global_payable, :particulars)
  end

  def voucher_series
    # Check if any of the parameters is empty
    if journal_params[:voucher_year].empty? || journal_params[:voucher_month].empty? || journal_params[:voucher_series].empty?
      return nil
    else
      return journal_params[:voucher_year] + journal_params[:voucher_month] + journal_params[:voucher_series]
    end
  end

end
