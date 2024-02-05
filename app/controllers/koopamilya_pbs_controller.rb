class KoopamilyaPbsController < ApplicationController
  before_action :set_koopamilya_pb, only: %i[ show edit update destroy ]

  # GET /koopamilya_pbs
  def index
    @koopamilya_pbs = KoopamilyaPb.all
  end

  # GET /koopamilya_pbs/1
  def show
  end

  # GET /koopamilya_pbs/new
  def new
    @koopamilya_pb = KoopamilyaPb.new
  end

  # GET /koopamilya_pbs/1/edit
  def edit
  end

  # POST /koopamilya_pbs
  def create
    @koopamilya_pb = KoopamilyaPb.new(koopamilya_pb_params)

    if @koopamilya_pb.save
      redirect_to @koopamilya_pb, notice: "Koopamilya pb was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /koopamilya_pbs/1
  def update
    if @koopamilya_pb.update(koopamilya_pb_params)
      redirect_to @koopamilya_pb, notice: "Koopamilya pb was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /koopamilya_pbs/1
  def destroy
    @koopamilya_pb.destroy
    redirect_to koopamilya_pbs_url, notice: "Koopamilya pb was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_koopamilya_pb
      @koopamilya_pb = KoopamilyaPb.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def koopamilya_pb_params
      params.require(:koopamilya_pb).permit(:koopamilya_ab_id, :coverage_amount, :benefit_id)
    end
end
