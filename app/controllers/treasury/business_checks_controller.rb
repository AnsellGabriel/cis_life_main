class Treasury::BusinessChecksController < ApplicationController
  before_action :set_check, only: %i[ show edit update destroy ]

  # GET /treasury/business_checks
  def index
    @checks = Treasury::BusinessCheck.all
  end

  # GET /treasury/business_checks/1
  def show
  end

  # GET /treasury/business_checks/new
  def new
    @check = Treasury::BusinessCheck.new
  end

  # GET /treasury/business_checks/1/edit
  def edit
  end

  # POST /treasury/business_checks
  def create
    @check = Treasury::BusinessCheck.new(check_params)

    if @check.save
      redirect_to @check, notice: "Business check was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /treasury/business_checks/1
  def update
    if @check.update(check_params)
      redirect_to @check, notice: "Business check was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /treasury/business_checks/1
  def destroy
    @check.destroy
    redirect_to checks_url, notice: "Business check was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check
      @check = Treasury::BusinessCheck.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def check_params
      params.require(:check).permit(:check_number, :check_date, :amount, :check_type)
    end
end
