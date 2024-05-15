class TransmittalsController < ApplicationController
  before_action :set_transmittal, only: %i[ show edit update destroy remove_or ]

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
      type = :mis
      @transmittals = Transmittal.where(transmittal_type: type)
    elsif current_user.is_und?
      type = :und
      @transmittals = Transmittal.where(transmittal_type: type)
    else 
      @transmittals = Transmittal.all
    end

    if params[:search].present?
      if current_user.is_mis?
        group_remit = GroupRemit.find_by(official_receipt: params[:search])
        payment = Payment.find_by(payable: group_remit)
        # payment = Payment.includes(:group_remit).find_by(group_remit: { official_receipt: params[:search]})
        cashier_entry = Treasury::CashierEntry.find_by(entriable: payment)
        # @transmittals = Transmittal.includes(:transmittal_ors).where(transmittal_ors: { transmittable: cashier_entry}, transmittal_type: type)
        @transmittals = @transmittals.includes(:transmittal_ors).where(transmittal_ors: { transmittable: cashier_entry})
      else 
        process_coverage = ProcessCoverage.includes(:group_remit).find_by(group_remit: { official_receipt: params[:search]})
        # @transmittals = Transmittal.includes(:transmittal_ors).where(transmittal_ors: { transmittable: process_coverage}, transmittal_type: type)
        @transmittals = @transmittals.includes(:transmittal_ors).where(transmittal_ors: { transmittable: process_coverage})
      end
    end


    @pagy, @transmittals = pagy(@transmittals, items: 2)
  end

  # GET /transmittals/1
  def show
    @transmittables = @transmittal.transmittal_ors
  end

  # GET /transmittals/new
  def new
    # raise 'errors'
    @type = params[:b_ids].present? ? "mis" : nil
    @group_remit_ids = GroupRemit.where(id: params[:b_ids]).pluck(:id)
    if Rails.env.development?
      @transmittal = Transmittal.new(description: FFaker::Lorem.phrase)
    else
      @transmittal = Transmittal.new
    end
    # @transmittal.transmittal_ors.build
  end

  # GET /transmittals/1/edit
  def edit
  end

  # POST /transmittals
  def create
    @transmittal = Transmittal.new(transmittal_params)
    @transmittal.transmittal_type = current_user.is_mis? ? "mis" : "und"
    @transmittal.set_code_and_type(current_user)
    
    if params[:transmittal][:transmittal_ors_attributes].nil? && params[:transmittal][:group_remit_ids].nil?
      # flash.now[:alert] = 
      # redirect_to :new, alert: "Please add ORs/PCs before saving transmittal."
      redirect_back fallback_location: { action: "new" }, alert: "Please add ORs/PCs before saving transmittal."
    else

      if @transmittal.save
          @transmittal.save_items(params[:transmittal][:transmittal_ors_attributes], params[:transmittal][:group_remit_ids])
          redirect_to @transmittal, notice: "Transmittal was successfully created."
      else
        render :new, status: :unprocessable_entity
      end

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

  def remove_or
    @transmittal_or = TransmittalOr.find(params[:or]).destroy
    redirect_to @transmittal, notice: "OR removed in the transmittal.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transmittal
      @transmittal = Transmittal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transmittal_params
      params.require(:transmittal).permit(:description, :transmittal_type, :group_remit_ids,
        #transmittal_ors_attributes: [:id, :transmittal_id, :transmittable_id, :transmittable_type, :_destroy]
        # transmittal_ors_attributes: [:global_owner] 
        transmittal_ors_attributes: [:global_transmittable, :_destroy]
      )
    end
end
