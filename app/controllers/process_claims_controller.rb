class ProcessClaimsController < ApplicationController
  before_action :set_process_claim, only: %i[ show edit update destroy show_coop claim_route claims_file claim_process update_status edit_ca update_ca ]
  # GET /process_claims

  # def claimable
  #   voucher = Accounting::Check.find(params[:v])
  #   claim = voucher.check_voucher_request.requestable
  #   total_business_checks = voucher.business_checks.sum(:amount)

  #   if voucher.amount != total_business_checks
  #     return redirect_to accounting_check_path(voucher), alert: "Claim cannot proceed. Total amount of business checks is not equal to the voucher amount."
  #   end

  #   ActiveRecord::Base.transaction do
  #     claim.update!(claim_route: 12, payment: 1)
  #     voucher.update!(claimable: true)
  #   end

  #   redirect_to accounting_check_path(voucher), notice: "Checks ready for claim"
  # end

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
    @claim_type_document = ClaimTypeDocument.where(claim_type: @process_claim.claim_type)
    @claim_type_document_ids = @process_claim.claim_attachments.pluck(:claim_type_document_id)
    @required_documents = @claim_type_document.where.not(id: @claim_type_document_ids)
    @check = @process_claim.check_voucher_request&.check_vouchers&.where(audit: [:pending_audit, :for_audit])&.last
    @audit_remarks = @check&.remarks
  end
  # GET /process_claims/new
  def new
    @process_claim = ProcessClaim.new
    @claim_documents = @process_claim.claim_documents.build
    @coop_member = CoopMember.find(params[:coop_member_id])
    @agreement = Agreement.find(params[:agreement_id])
    @group_remit = @agreement.group_remits.joins(:batches)
                           .where(batches: { coop_member_id: @coop_member.id })
                           .order("group_remits.created_at DESC")
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

    if Rails.env.development?
      set_dummy_value
    end
    # raise "error"
  end

  def new_ca
    # raise "errors"
    @process_claim = ProcessClaim.new
    @coop_member = CoopMember.find(params[:cm])
    @process_claim.claimable = @coop_member
    @process_claim.cooperative = @coop_member.cooperative
    @claim_cause = @process_claim.build_claim_cause
    @agreement = Agreement.where(cooperative: @process_claim.cooperative)
    set_dummy_value
  end

  def create_coop
    @process_claim = ProcessClaim.new(process_claim_params)
    @process_claim.entry_type = :coop
    @process_claim.claim_route = :file_claim
    @rel_css = process_claim_params[:relationship].empty? ? "is-invalid" : "is-valid"

    unless process_claim_params[:date_incident].empty?
      @process_claim.age = @process_claim.get_age.to_i
    end

    respond_to do |format|
      if @process_claim.save

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

  def create_ca
    @process_claim = ProcessClaim.new(process_claim_params)
    @process_claim.entry_type = :claim
    @process_claim.claim_route = :filed_by_analyst
    @process_claim.age = @process_claim.get_age.to_i

    respond_to do |format|
      if @process_claim.save
        @process_claim.process_track.create(route_id: 17, user: current_user)
        format.html { redirect_to show_coop_process_claim_path(@process_claim), notice: "Claims was successfully added." }
        format.json { render :show, status: :created, location: @anniversary }
      else
        format.html { render :new_ca, status: :unprocessable_entity }
        format.json { render json: @process_claim.errors, status: :unprocessable_entity }
        # format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def update_ca
    if @process_claim.update(process_claim_params)

        redirect_to index_show_process_claims_path(p: 17), notice: "Process claim was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # GET /process_claims/1/edit
  def edit
  end

  def edit_ca
  end

  def claims_file
    if @process_claim.claim_cause.present?
      @claim_cause = @process_claim.claim_cause
    else
      @claim_cause = @process_claim.build_claim_cause
    end
    @process_claim.date_file = Date.today if @process_claim.date_file.nil?
  end

  def claim_process
    @check = @process_claim.check_voucher_request&.check_vouchers&.where(audit: [:pending_audit, :for_audit])&.last
    @audit_remarks = @check&.remarks
  end

  # POST /process_claims
  def create
    @process_claim = ProcessClaim.new(process_claim_params)
    batch = Batch.find(process_claim_params[:batch_id])
    coop_member = batch.coop_member
    agreement = Agreement.find(process_claim_params[:agreement_id])
    @group_remit = agreement.group_remits.joins(:batches)
                           .where(batches: { coop_member_id: coop_member.id })
                           .order("group_remits.created_at DESC")
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
          pt = ProcessTrack.create(route_id: 2, user: current_user, trackable: @process_claim)
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
          import_product_benefit if @process_claim.submitted?
          @process_claim.update!(claim_route: @claim_track.route_id, status: :process, claim_filed: 1, processing: 0, approval: 0, payment: 0)
          format.html { redirect_to claims_file_process_claim_path(@process_claim), notice: "#{@process_claim.claim_route.to_s.humanize.titleize} by #{current_user}"  }
        elsif @claim_track.route_id == 3
          @process_claim.update!(claim_route: @claim_track.route_id, processing: 1)
          format.html { redirect_to claim_process_process_claim_path(@process_claim), notice: "#{@process_claim.claim_route.to_s.humanize.titleize} by #{current_user}"  }
          # ClaimsMailer.with(process_claim: @process_claim).new_claim_email.deliver_later
        elsif @claim_track.route_id == 5
          # RegisterMailer.with(registration: @registration, event_hub: @event_hub).register_created.deliver_later
          @process_claim.update!(claim_route: @claim_track.route_id, processing: 1)
          format.html { redirect_to claim_process_process_claim_path(@process_claim), notice: "#{@process_claim.claim_route.to_s.humanize.titleize} by #{current_user}"  }

        elsif @claim_track.route_id == 8
          ActiveRecord::Base.transaction do
            @process_claim.update!(claim_route: @claim_track.route_id, status: :approved, approval: 1)
            # request = @process_claim.create_claim_request_for_payment(
            #   amount: @process_claim.get_benefit_claim_total,
            #   status: :pending,
            #   description: "Claim Request for Payment",
            #   analyst: current_user.userable.signed_fullname
            # )
            # request = @process_claim.create_check_voucher_request(
            #   amount: @process_claim.get_benefit_claim_total,
            #   status: :pending,
            #   description: "Claim Request for Payment",
            #   analyst: current_user.userable.signed_fullname
            # )

            if @process_claim.check_voucher_request&.check_vouchers&.pending_audit.present?
              #* put the check voucher to pending here
              @process_claim.check_voucher_request.check_vouchers.pending_audit.last.update(audit: :for_audit)
            else
              request = CheckVoucherRequestService.new(@process_claim, @process_claim.get_benefit_claim_total, :claims_payment, current_user)

              if request.create_request
                format.html { redirect_to show_coop_process_claim_path(@process_claim), notice: "#{@process_claim.claim_route.to_s.humanize.titleize} by #{current_user}"  }
              else
                format.html { redirect_to show_coop_process_claim_path(@process_claim), alert: "Something went wrong" }
              end
            end
          end
        else
          @required_docs = @process_claim.claim_type.claim_type_documents.where(required: true)
          @uploaded_docs = @process_claim.claim_attachments

          missing_docs = @required_docs.pluck(:id) - @uploaded_docs.pluck(:claim_type_document_id)

          if missing_docs.empty?
            @process_claim.update_attribute(:claim_route, @claim_track.route_id)
            format.html { redirect_to show_coop_process_claim_path(@process_claim), notice: "#{@process_claim.claim_route.to_s.humanize.titleize} by #{current_user}"  }
          else
            format.html { redirect_to show_coop_process_claim_path(@process_claim), alert: "Please upload the required documents" }
          end
        end

        format.json { render :show, status: :ok, location: @process_claim }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @process_claim.errors, status: :unprocessable_entity }
      end
    end
  end


  def import_product_benefit
    if @process_claim.claim_type == ClaimType.find_by(name: "Hospital Confinement Claim")
      @benefit = Benefit.find_by(name: "Hospital Income Benefit")
      @process_claim.claim_benefits.create(process_claim_id: @process_claim.id, benefit: @benefit, amount: @process_claim.claim_confinements.sum(:amount))
    else
      @product_benefit = ProductBenefit.where(agreement_benefit: @process_claim.agreement_benefit)
      @product_benefit.each do | pb |
        @process_claim.claim_benefits.create(process_claim_id: @process_claim.id, benefit_id: pb.benefit_id, amount: pb.coverage_amount)
      end
    end
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
    # raise "error"
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
    params.require(:process_claim).permit(:cooperative_id, :claim_route, :agreement_id, :agreement_benefit_id, :batch_id, :claimable_id, :cause_id, :claim_type_id, :date_file, :claim_filed, :processing, :approval, :payment, :claimable_type, :date_incident, :entry_type, :claimant_name, :claimant_email, :claimant_contact_no, :nature_of_claim, :agreement_benefit_id, :relationship,
      claim_documents_attributes: [:id, :document, :document_type, :_destroy],
      process_tracks_attributes: [:id, :description, :route_id, :trackable_type, :trackable_id ],
      claim_benefits_param: [:id, :benefit_id, :amount, :status],
      claim_cause_attributes: [:id, :acd, :ucd, :osccd, :icd],
      claim_coverage_attributes: [:id, :amount_benefit, :coverage_type, :coverageale],
      claim_remark_attributes: [:id, :user_id, :status, :remark, :coop, :read],
      claim_attachment_attributes: [:id, :claim_type_id, :doc],
      claim_confinement_attributes: [:id, :date_admit, :date_discharge, :terms, :amount])
  end

  def set_dummy_value
    first_name = FFaker::NamePH.first_name
    @process_claim.claimant_name = first_name + " " + FFaker::NamePH.last_name
    @process_claim.claimant_contact_no = FFaker::PhoneNumber.phone_number
    @process_claim.claimant_email = first_name + "@gmail.com"
  end
end
