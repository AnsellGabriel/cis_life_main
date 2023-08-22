class ProcessClaimsController < ApplicationController
  before_action :set_process_claim, only: %i[ show edit update destroy show_coop claim_route claims_file claim_process ]

  # GET /process_claims
  def index
    @process_claims = ProcessClaim.where(claim_route: :submitted)
  end
  
  def index_coop
    @process_claims = ProcessClaim.where(cooperative: @cooperative)

  end

  def index_show 
    @process_claims = ProcessClaim.where(claim_route: params[:p])
    @display = ProcessClaim.get_route(params[:p].to_i).to_s.humanize.titleize
    # raise "errors"
  end
  # GET /process_claims/1
  def show
    
  end

  def show_coop 
    @agreement_benefit = AgreementBenefit.where(agreement: @process_claim.agreement)
  end
  # GET /process_claims/new
  def new
    @process_claim = ProcessClaim.new
    @claim_documents = @process_claim.claim_documents.build
    @coop_member = CoopMember.find(params[:coop_member_id])
    @agreement = Agreement.find(params[:agreement_id])
    @group_remit = @agreement.group_remits.joins(:batches)
                           .where(batches: { coop_member_id: @coop_member.id })
                           .order('group_remits.created_at DESC')
                           .limit(1)
                           .first
    @batch = @group_remit.batches.find_by(coop_member_id: @coop_member.id)

  end

  def new_coop
    @process_claim = ProcessClaim.new
    @process_claim.agreement = Agreement.find(params[:a])
    @process_claim.agreement_benefit = AgreementBenefit.find(params[:ab])
    @coop_member = CoopMember.find(params[:cm])
    @process_claim.claimable = @coop_member
    @process_claim.cooperative = @coop_member.cooperative
    # raise "error"
  end

  def create_coop 
    @process_claim = ProcessClaim.new(process_claim_params)
    @process_claim.entry_type = "coop"
    @process_claim.claim_route = :file_claim
    @process_claim.age = @process_claim.get_age.to_i
    
    respond_to do |format|
      if @process_claim.save!
        @process_claim.process_track.create(route_id: 0, user: current_user)
        format.html { redirect_to show_coop_process_claim_path(@process_claim), notice: "Claims was successfully added." }
        format.json { render :show, status: :created, location: @anniversary }
      else
        format.html { render :new_coop, status: :unprocessable_entity }
        format.json { render json: @process_claim.errors, status: :unprocessable_entity }
        # format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  # GET /process_claims/1/edit
  def edit
  end

  def claims_file
    if @process_claim.claim_cause.present? 
      @claim_cause = @process_claim.claim_cause
    else
      @claim_cause = @process_claim.build_claim_cause
    end
  end

  def claim_process 
    
  end
  # POST /process_claims
  def create
    @process_claim = ProcessClaim.new(process_claim_params)
    batch = Batch.find(process_claim_params[:batch_id])
    coop_member = batch.coop_member
    agreement = Agreement.find(process_claim_params[:agreement_id])
    @group_remit = agreement.group_remits.joins(:batches)
                           .where(batches: { coop_member_id: coop_member.id })
                           .order('group_remits.created_at DESC')
                           .limit(1)
                           .first

    expiry_date = @group_remit.expiry_date
    incident_date = process_claim_params[:date_incident].to_date
    difference_in_months = (expiry_date.year * 12 + expiry_date.month) - (incident_date.year * 12 + incident_date.month) if incident_date != nil

    if process_claim_params[:relationship].nil?

      begin
        @process_claim.relationship = BatchBeneficiary.find(process_claim_params[:claimant_name]).member_dependent.relationship
        @process_claim.claimant_name = BatchBeneficiary.find(process_claim_params[:claimant_name]).member_dependent.full_name.titleize
      rescue ActiveRecord::RecordNotFound
        return redirect_to new_process_claim_path, alert: "The claim cannot be processed. The claimant name is not found."
      end 

    end

    if difference_in_months != nil && difference_in_months > 60
      return redirect_to new_process_claim_path, alert: "The claim cannot be processed. The incident date has passed the 5-year claim period."
    end

    if params[:process_claim][:claimable_type] == "Batch"
      @process_claim.claimable = Batch.find(params[:process_claim][:claimable_id])
    else
      @process_claim.claimable = BatchDependent.find(params[:process_claim][:claimable_id])
    end

    begin

      respond_to do |format|
        if @process_claim.save!
          pt = ProcessTrack.create(route_id: 2, user_id: current_user, trackable: @process_claim)
          format.html { redirect_to member_agreements_coop_member_path(coop_member), notice: "Claims submitted" }
        end
      end

    rescue ActiveRecord::RecordInvalid => e
      redirect_to new_process_claim_path, alert: "The claim cannot be processed. Please check: #{e.record.errors.full_messages.join(', ')}"
    end
    
  end

  def claim_route 
    # @process_claim.claim_track = ProcessTrack.build
    # @claim_track = ProcessTrack.new
    @claim_track = @process_claim.process_track.build
    @claim_track.route_id = params[:p]
    @claim_track.user_id = current_user.id
    respond_to do |format|
      if @claim_track.save

        if @claim_track.route_id == 2
          # raise "error"
          @process_claim.update(claim_route: @claim_track.route_id, date_file: Time.now, claim_filed: 0, processing: 0, approval: 0, payment: 0)
          import_product_benefit
          format.html { redirect_to claims_file_process_claim_path(@process_claim), notice: "#{@process_claim.claim_route.to_s.humanize.titleize} by #{current_user}"  }
        else
          @process_claim.update_attribute(:claim_route, @claim_track.route_id)
          format.html { redirect_to show_coop_process_claim_path(@process_claim), notice: "#{@process_claim.claim_route.to_s.humanize.titleize} by #{current_user}"  }
        end

        format.json { render :show, status: :ok, location: @process_claim }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @process_claim.errors, status: :unprocessable_entity }
      end
    end
  end

  def import_product_benefit 
    # @product_benefit = ProductBenefit.where(agreement_benefit: @process_claim.agreement_benefit)
    # @product_benefit.each do | pb |
    #   @process_claim.claim_benefits.create(process_claim_id: @process_claim.id, benefit_id: pb.benefit_id, amount: pb.coverage_amount)
    # end
    @batch = Batch.where(coop_member: @process_claim.claimable, agreement_benefit: @process_claim.agreement_benefit)
    @batch.each do |b|
      @process_claim.claim_coverages.create(process_claim: @process_claim, coverageable: b)
    end
    # @process_claim.claim_benefits.create(
    #   @product_benefit.map { |pb| { process_claim_id: @process_claim.id, benefit_id: pb.benefit_id, amount: pb.coverage_amount } }
    # )
  end
  # PATCH/PUT /process_claims/1
  def update
    if @process_claim.update(process_claim_params)
      if @process_claim.claim_filed? 
        redirect_to index_show_process_claims_path(p: 2), notice: "Process claim was successfully updated."
      else
        redirect_to index_show_process_claims_path(p: 3), notice: "Process claim was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /process_claims/1
  def destroy
    @process_claim.destroy
    redirect_to process_claims_url, notice: "Process claim was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_claim
      @process_claim = ProcessClaim.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def process_claim_params
      params.require(:process_claim).permit(:cooperative_id, :claim_route, :agreement_id, :batch_id, :claimable_id, :cause_id, :date_file, :claim_filed, :processing, :approval, :payment, :claimable_type, :date_incident, :entry_type, :claimant_name, :claimant_email, :claimant_contact_no, :nature_of_claim, :agreement_benefit_id, :relationship, 
        claim_documents_attributes: [:id, :document, :document_type, :_destroy],
        process_tracks_attributes: [:id, :description, :route_id, :trackable_type, :trackable_id ],
        claim_benefits_param: [:id, :benefit_id, :amount, :status],
        claim_cause_attributes: [:id, :acd, :ucd, :osccd, :icd],
        claim_coverage_attributes: [:id, :amount_benefit, :coverage_type, :coverageale],
        claim_remark_attributes: [:id, :user_id, :status, :remark])
    end

end
