class ClaimRemarksController < ApplicationController
  before_action :set_claim_remark, only: %i[ show edit update destroy ]
  def new
    @process_claim = ProcessClaim.find(params[:v])
    @claim_remark = @process_claim.claim_remarks.build
    @change_status = params[:s]
    set_dummy_param
  end
  def set_dummy_param
    @claim_remark.user = current_user
    # @claim_remark.status = params[:s]
    @claim_remark.remark = FFaker::HealthcareIpsum.paragraph
    
  end
  def edit
  end

  def create 
    @process_claim = ProcessClaim.find(params[:v])
    @claim_remark = @process_claim.claim_remarks.build(claim_remark_params)
    @claim_remark.user = current_user
    @status = params[:s]
    respond_to do |format|
      if @claim_remark.save
        unless params[:s].blank?
          change_status(params[:s])
          # puts "@@@ ikaw"
        end
        format.html { redirect_back fallback_location: claim_process_process_claim_path(@process_claim), notice: "Claim remark was successfully created." }
        format.json { render :show, status: :created, location: @claim_remark }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @claim_remark.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def update 
    respond_to do |format|
      if @claim_remark.update(claim_remark_params)
        format.html { redirect_back fallback_location: @process_claim, notice: "Claim remark was successfully updated." }
        format.json { render :show, status: :ok, location: @claim_remark }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @claim_remark.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @claim_remark.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: @process_claim, notice: "Claim remark was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_claim_remark
      @claim_remark = ClaimRemark.find(params[:id])
      @process_claim = @claim_remark.process_claim
    end

    # Only allow a list of trusted parameters through.
    def claim_remark_params
      params.require(:claim_remark).permit(:process_claim_id, :user_id, :status, :remark)
    end
end
