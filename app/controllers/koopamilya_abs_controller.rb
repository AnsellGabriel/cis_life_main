class KoopamilyaAbsController < ApplicationController
  before_action :set_koopamilya_ab, only: %i[ show edit update destroy ]

  # GET /koopamilya_abs
  def index
    @koopamilya_abs = KoopamilyaAb.all
  end

  # GET /koopamilya_abs/1
  def show
  end

  # GET /koopamilya_abs/new
  def new
    @koopamilya_ab = KoopamilyaAb.new
  end

  # GET /koopamilya_abs/1/edit
  def edit
  end

  # POST /koopamilya_abs
  def create
    @koopamilya_ab = KoopamilyaAb.new(koopamilya_ab_params)

    if @koopamilya_ab.save
      redirect_to @koopamilya_ab, notice: "Koopamilya ab was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /koopamilya_abs/1
  def update
    if @koopamilya_ab.update(koopamilya_ab_params)
      redirect_to @koopamilya_ab, notice: "Koopamilya ab was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /koopamilya_abs/1
  def destroy
    @koopamilya_ab.destroy
    redirect_to koopamilya_abs_url, notice: "Koopamilya ab was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_koopamilya_ab
      @koopamilya_ab = KoopamilyaAb.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def koopamilya_ab_params
      params.require(:koopamilya_ab).permit(:name, :min_age, :max_age, :insured_type, :exit_age, :groupings)
    end
end
