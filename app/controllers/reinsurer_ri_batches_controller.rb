class ReinsurerRiBatchesController < ApplicationController
  before_action :set_reinsurer_ri_batch, only: %i[ show edit update destroy ]

  # GET /reinsurer_ri_batches
  def index
    @reinsurer_ri_batches = ReinsurerRiBatch.all
  end

  # GET /reinsurer_ri_batches/1
  def show
  end

  # GET /reinsurer_ri_batches/new
  def new
    ri_batch = ReinsuranceBatch.find(params[:reinsurance_batch])
    @reinsurer_ri_batch = ReinsurerRiBatch.new(reinsurance_batch: ri_batch)
  end

  # GET /reinsurer_ri_batches/1/edit
  def edit
  end

  # POST /reinsurer_ri_batches
  def create
    @reinsurer_ri_batch = ReinsurerRiBatch.new(reinsurer_ri_batch_params)

    if @reinsurer_ri_batch.save
      redirect_to @reinsurer_ri_batch, notice: "Reinsurer ri batch was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reinsurer_ri_batches/1
  def update
    if @reinsurer_ri_batch.update(reinsurer_ri_batch_params)
      redirect_to @reinsurer_ri_batch, notice: "Reinsurer ri batch was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reinsurer_ri_batches/1
  def destroy
    @reinsurer_ri_batch.destroy
    redirect_to reinsurer_ri_batches_url, notice: "Reinsurer ri batch was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reinsurer_ri_batch
      @reinsurer_ri_batch = ReinsurerRiBatch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reinsurer_ri_batch_params
      params.require(:reinsurer_ri_batch).permit(:reinsurance_batch_id, :reinsurer_id)
    end
end
