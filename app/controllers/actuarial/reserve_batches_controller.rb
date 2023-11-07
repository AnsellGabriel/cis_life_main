class Actuarial::ReserveBatchesController < ApplicationController
  before_action :set_actuarial_reserve_batch, only: %i[ show edit update destroy ]

  # GET /actuarial/reserve_batches
  def index
    @actuarial_reserve_batches = Actuarial::ReserveBatch.all
  end

  # GET /actuarial/reserve_batches/1
  def show
  end

  # GET /actuarial/reserve_batches/new
  def new
    @actuarial_reserve_batch = Actuarial::ReserveBatch.new
  end

  # GET /actuarial/reserve_batches/1/edit
  def edit
  end

  # POST /actuarial/reserve_batches
  def create
    @actuarial_reserve_batch = Actuarial::ReserveBatch.new(actuarial_reserve_batch_params)

    if @actuarial_reserve_batch.save
      redirect_to @actuarial_reserve_batch, notice: "Reserve batch was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /actuarial/reserve_batches/1
  def update
    if @actuarial_reserve_batch.update(actuarial_reserve_batch_params)
      redirect_to @actuarial_reserve_batch, notice: "Reserve batch was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /actuarial/reserve_batches/1
  def destroy
    @actuarial_reserve_batch.destroy
    redirect_to actuarial_reserve_batches_url, notice: "Reserve batch was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_actuarial_reserve_batch
      @actuarial_reserve_batch = Actuarial::ReserveBatch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def actuarial_reserve_batch_params
      params.require(:actuarial_reserve_batch).permit(:actuarial_reserve_id, :batch_id, :term, :rate, :coverage_less_ri, :prem_less_ri, :duration, :first_term, :second_term, :third_term, :unearned_prem, :first_adv_prem, :second_adv_prem, :reserve, :cov_less_ret, :prem_less_ret, :unearned_pr, :first_adv_pr, :second_adv_pr, :reserve_ret)
    end
end
