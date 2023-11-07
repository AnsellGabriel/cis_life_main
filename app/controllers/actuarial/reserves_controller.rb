class Actuarial::ReservesController < ApplicationController
  before_action :set_actuarial_reserve, only: %i[ show edit update destroy ]

  # GET /actuarial/reserves
  def index
    @actuarial_reserves = Actuarial::Reserve.all
  end

  # GET /actuarial/reserves/1
  def show
    @pagy, @reserve_batches = pagy(@actuarial_reserve.reserve_batches, items: 2)

    @chart_data_1 = [
      ["#{@actuarial_reserve.first_term.year} Unearned Premium", @actuarial_reserve.total_unearned_prem],
      ["#{@actuarial_reserve.second_term.year} Advance Premium", @actuarial_reserve.total_first_advance_prem],
      ["#{@actuarial_reserve.third_term.year} Advance Premium", @actuarial_reserve.total_second_advance_prem]
    ]
    @chart_data_2 = [
      ["#{@actuarial_reserve.first_term.year} Unearned Premium", @actuarial_reserve.total_unearned_pr],
      ["#{@actuarial_reserve.second_term.year} Advance Premium", @actuarial_reserve.total_first_advance_pr],
      ["#{@actuarial_reserve.third_term.year} Advance Premium", @actuarial_reserve.total_second_advance_pr]
    ]
  end

  # GET /actuarial/reserves/new
  def new
    @actuarial_reserve = Actuarial::Reserve.new
  end

  # GET /actuarial/reserves/1/edit
  def edit
  end

  # POST /actuarial/reserves
  def create

    @actuarial_reserve = Actuarial::Reserve.new(actuarial_reserve_params)
    @actuarial_reserve.set_default_dates(params[:actuarial_reserve][:n_date])

    if @actuarial_reserve.save
      @actuarial_reserve.get_reserve_batches
      @actuarial_reserve.update_totals
      redirect_to @actuarial_reserve, notice: "Reserve was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /actuarial/reserves/1
  def update
    if @actuarial_reserve.update(actuarial_reserve_params)
      redirect_to @actuarial_reserve, notice: "Reserve was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /actuarial/reserves/1
  def destroy
    @actuarial_reserve.destroy
    redirect_to actuarial_reserves_url, notice: "Reserve was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_actuarial_reserve
      @actuarial_reserve = Actuarial::Reserve.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def actuarial_reserve_params
      params.require(:actuarial_reserve).permit(:first_term, :second_term, :third_term, :total_unearned_prem, :total_first_advance_prem, :total_second_advance_prem, :total_reserve, :total_unearned_pr, :total_first_advance_pr, :total_second_advance_pr, :total_reserve_ret, :plan_id)
    end
end
