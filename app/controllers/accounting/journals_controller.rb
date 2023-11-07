class Accounting::JournalsController < ApplicationController
  before_action :set_journal, only: %i[ show edit update destroy ]
  before_action :set_payables, only: %i[ new edit create update]

  # GET /accounting/journals
  def index
    # byebug

    if params[:voucher_yr].present? || params[:voucher_month].present? || params[:voucher_series].present?
      @journals = Accounting::Journal.where(type: 'Accounting::Journal').where("voucher like ?", "%#{params[:voucher_yr] + params[:voucher_month] + params[:voucher_series]}%")
    else
      @journals = Accounting::Journal.all
    end

    @pagy, @journals = pagy(@journals, items: 10)
  end

  # GET /accounting/journals/1
  def show
  end

  # GET /accounting/journals/new
  def new
    last_voucher = Accounting::Journal.maximum(:voucher)
    initiate_voucher = last_voucher ? last_voucher + 1 : 0

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
    journal_params[:voucher_year] + journal_params[:voucher_month] + journal_params[:voucher_series]
  end
end
