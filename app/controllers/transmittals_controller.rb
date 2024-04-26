class TransmittalsController < ApplicationController
  before_action :set_transmittal, only: %i[ show edit update destroy ]

  # GET /transmittals
  def index
    # @transmittals = case current_user
    # when 
    #   Transmittal.where(transmittal_type: :mis)
    # else
    #   Transmittal.where(transmittal_type: :und)
    # end
    # @transmittals = Transmittal.all
    
    if current_user.is_mis?
      @transmittals = Transmittal.where(transmittal_type: :mis)
    elsif current_user.is_und?
      @transmittals = Transmittal.where(transmittal_type: :und)
    else 
      @transmittals = Transmittal.all
    end
  end

  # GET /transmittals/1
  def show
    @transmittables = @transmittal.transmittal_ors
  end

  # GET /transmittals/new
  def new
    @transmittal = Transmittal.new
    # @transmittal.transmittal_ors.build
  end

  # GET /transmittals/1/edit
  def edit
  end

  # POST /transmittals
  def create
    @transmittal = Transmittal.new(transmittal_params)

    @transmittal.set_code_and_type(@transmittal.transmittal_type, current_user)
    
    if @transmittal.save
      @transmittal.save_items(params[:transmittal][:transmittal_ors_attributes])
      redirect_to @transmittal, notice: "Transmittal was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transmittals/1
  def update
    if @transmittal.update(transmittal_params)
      redirect_to @transmittal, notice: "Transmittal was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /transmittals/1
  def destroy
    @transmittal.destroy
    redirect_to transmittals_url, notice: "Transmittal was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transmittal
      @transmittal = Transmittal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transmittal_params
      params.require(:transmittal).permit(:description, :transmittal_type,
        #transmittal_ors_attributes: [:id, :transmittal_id, :transmittable_id, :transmittable_type, :_destroy]
        # transmittal_ors_attributes: [:global_owner] 
        transmittal_ors_attributes: [:global_transmittable, :_destroy]
      )
    end
end
