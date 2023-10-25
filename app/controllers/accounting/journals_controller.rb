class Accounting::JournalsController < ApplicationController
  before_action :set_accounting_journal, only: %i[ show edit update destroy ]

  # GET /accounting/journals
  def index
    @accounting_journals = Accounting::Journal.all
  end

  # GET /accounting/journals/1
  def show
  end

  # GET /accounting/journals/new
  def new
    @accounting_journal = Accounting::Journal.new
  end

  # GET /accounting/journals/1/edit
  def edit
  end

  # POST /accounting/journals
  def create
    @accounting_journal = Accounting::Journal.new(accounting_journal_params)

    if @accounting_journal.save
      redirect_to @accounting_journal, notice: "Journal was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounting/journals/1
  def update
    if @accounting_journal.update(accounting_journal_params)
      redirect_to @accounting_journal, notice: "Journal was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounting/journals/1
  def destroy
    @accounting_journal.destroy
    redirect_to accounting_journals_url, notice: "Journal was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accounting_journal
      @accounting_journal = Accounting::Journal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def accounting_journal_params
      params.fetch(:accounting_journal, {})
    end
end
