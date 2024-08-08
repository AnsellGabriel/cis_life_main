
class Claims::ProcessClaimsController < ApplicationController
  include ProcessClaimHelper
  before_action :set_process_claim, only: %i[ show edit update destroy show_coop show_ca claim_route claims_file claim_process update_status edit_ca update_ca print_sheet edit_coop update_coop approve_claim_debit]

  def index
    # @process_claims = Claims::ProcessClaim.all
    # @q = Claims::ProcessClaim.ransack(params[:q])
    # @pagy, @process_claims = @q.result(distinct: true)
    # @pagy, @cooperatives = pagy(@q, items: 10 )

    @q = Claims::ProcessClaim.ransack(params[:q])
    @process_claims = @q.result(distinct: true)

    # use pagy
    @pagy, @process_claims = pagy(@process_claims, items: 5)
  end

  def index_coop
    @process_claims = Claims::ProcessClaim.where(cooperative: @cooperative)
  end

  def index_show
    @q = Claims::ProcessClaim.ransack(params[:q])
    @process_claims = @q.result(distinct: true)
    unless params[:p].nil?
      @process_claims = Claims::ProcessClaim.where(claim_route: params[:p])
      @display = Claims::ProcessClaim.get_route(params[:p].to_i).to_s.humanize.titleize
    end
    unless params[:s].nil?
      @process_claims = Claims::ProcessClaim.where(status: params[:s])
      case params[:s]
      when 0
        @display = "Approved Claims"
      end
    end
    # use pagy
    @pagy, @process_claims = pagy(@process_claims, items: 5)
    render :index
    # raise "errors"
  end

  def index_claim_type 
    @q = Claims::ProcessClaim.ransack(params[:q])
    @process_claims = @q.result(distinct: true)
    @claim_type = Claims::ClaimType.find(params[:p])
    @process_claims = @process_claims.where(claim_type: @claim_type)
    @pagy, @process_claims = pagy(@process_claims, items: 5)
    render :index
  end

  def print_sheet
    # respond_to do |format|
    #   format.html
    #   format.pdf do
        pdf = ClaimsPdf.new(@process_claim, view_context)
        send_data pdf.render,
          filename: "#{@process_claim.insurable.get_fullname}.pdf",
          type: 'application/pdf',
          disposition: 'inline'
    #   end
    # end
    # pdf = Prawn::Document.new
    # pdf = ClaimsPrintSheetPdf.new
    # pdf.text "Claims Processing Sheet"
    # pdf.text @process_claim.coop_member.get_fullname.titleize, size: 15, style: :bold
    # pdf.text @process_claim.cooperative.name
    # send_data(pdf.render, filename: "#{@process_claim.coop_member.get_fullname}.pdf", type: 'application/pdf', disposition: 'inline')
  end
  # GET /process_claims/1
  def show

  end

  def show_coop
    @agreement_benefit = AgreementBenefit.where(agreement: @process_claim.agreement)
    @claim_type_document = Claims::ClaimTypeDocument.where(claim_type: @process_claim.claim_type)
    @claim_type_document_ids = @process_claim.claim_attachments.pluck(:claim_type_document_id)
    @required_documents = @claim_type_document.where.not(id: @claim_type_document_ids)
    @voucher = @process_claim.voucher_requests&.last&.vouchers&.where(audit: [:pending_audit, :for_audit])&.last
    @audit_remarks = @check&.remarks
  end

  def show_ca
    if @process_claim.debit_advice?
      @bank = @process_claim.voucher_request.account
    end
  end
  # GET /process_claims/new
  def new
    @process_claim = Claims::ProcessClaim.new
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
    # if params[:lb].present?
    #   @loan_batch = LoanInsurance::Batch.find(params[:lb])
    # end

    @process_claim = Claims::ProcessClaim.new
    @process_claim.agreement = Agreement.find(params[:a]) if params[:a].present?
    @process_claim.agreement_benefit = AgreementBenefit.find(params[:ab]) if params[:ab].present?
    @coop_member = CoopMember.find(params[:cm])
    @process_claim.coop_member = @coop_member
    @process_claim.cooperative = @coop_member.cooperative


    if Rails.env.development?
      set_dummy_value
    end
    # raise "error"
  end

  def new_ca
    # raise "errors"
    @process_claim = Claims::ProcessClaim.new
    @coop_member = CoopMember.find(params[:cm])
    @process_claim.insurable = @coop_member
    @process_claim.cooperative = @coop_member.cooperative
    @claim_cause = @process_claim.build_claim_cause
    @agreement = Agreement.where(cooperative: @process_claim.cooperative)
    set_dummy_value if Rails.env.development?
  end

  def create_coop
    # raise "errors"
    # if params[:lb].present?
    #   @loan_batch = LoanInsurance::Batch.find(params[:lb])
    # end

    @process_claim = Claims::ProcessClaim.new(process_claim_params)
    @process_claim.entry_type = :coop
    @process_claim.claim_route = :coop_file
    @process_claim.status = :pending
    @rel_css = process_claim_params[:relationship].empty? ? "is-invalid" : "is-valid"
    @coop_member = CoopMember.find(process_claim_params[:coop_member_id])


    unless process_claim_params[:date_incident].empty?
      @process_claim.age = @process_claim.get_age.to_i
    end

    respond_to do |format|
      if @process_claim.save
        if @loan_batch.present?
          @loan_batch.process_claim_id = @process_claim.id
          @loan_batch.save!
        end

        @process_claim.process_tracks.create(route_id: 0, user: current_user)
        format.html { redirect_to show_coop_claims_process_claim_path(@process_claim), notice: "Claims was successfully added." }
        format.json { render :show, status: :created, location: @anniversary }
      else
        format.html { render :new_coop, status: :unprocessable_entity }
        format.json { render json: @process_claim.errors, status: :unprocessable_entity }
        # format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def create_ca
    @process_claim = Claims::ProcessClaim.new(process_claim_params)
    @process_claim.entry_type = :claim
    @process_claim.claim_route = :analyst_file if @process_claim.id.nil?
    @process_claim.status = :pending
    @agreement = Agreement.find(params[:claims_process_claim][:agreement_id])
    @process_claim.agreement_benefit_id = nil if @agreement.plan.acronym == "LPPI"
    # @process_claim.micro = 1 if @process_claim.agreement.plan.micro
    @process_claim.age = @process_claim.get_age.to_i
    # raise "errors"

    respond_to do |format|
      if @process_claim.save!
        @process_claim.process_tracks.create(route_id: 17, user: current_user)
        format.html { redirect_to claim_process_claims_process_claim_path(@process_claim), notice: "Claims was successfully added." }
        format.json { render :show, status: :created, location: @process_claim }
      else
        format.html { render :new_ca, status: :unprocessable_entity }
        format.json { render json: @process_claim.errors, status: :unprocessable_entity }
        # format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def update_ca
    # if @process_claim.claim_cause.nil?
    #   if @process_claim.claim_cause.save
    #     redirect_to claim_process_claims_process_claim_path(@process_claim), notice: "Claims was successfully added."
    #   else
    #     render :edit, status: :unprocessable_entity
    #   end
    # else
      if @process_claim.update(process_claim_params)
          redirect_to claim_process_claims_process_claim_path(@process_claim), notice: "Process claim was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    # end
  end

  # GET /process_claims/1/edit
  def edit
    @coop_member = @process_claim.coop_member
  end

  def edit_ca
    if @process_claim.claim_cause.nil?
      @claim_cause = @process_claim.build_claim_cause
    end
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
    @voucher = @process_claim.voucher_requests&.last&.vouchers&.where(audit: [:pending_audit, :for_audit])&.last
    @audit_remarks = @voucher&.remarks
    @cooperative = @process_claim.cooperative
    # @payout_type = @process_claim.voucher_requests&.last&.vouchers&.where(audit: [:pending_audit, :for_audit])&.last
    @audit_remarks = @payout_type&.remarks
    unless @process_claim.claim_reinsurance.nil?
      @reinsurers = Reinsurer.all
      @claim_reinsurance = @process_claim.claim_reinsurance
      @coverage_reinsurances = Claims::ClaimCoverageReinsurance.where(claim_reinsurance: @claim_reinsurance)
    end
    # if @process_claim.debit_advice?
    #   @bank = @process_claim.voucher_request.account
    # end
  end

  def approve_claim_debit
    @cooperative  = @process_claim.cooperative
  end

  # POST /process_claims
  def create
    @process_claim = Claims::ProcessClaim.new(process_claim_params)
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

    if params[:process_claim][:coop_member_type] == "Batch"
      @process_claim.coop_member = Batch.find(params[:process_claim][:coop_member_id])
    else
      @process_claim.coop_member = BatchDependent.find(params[:process_claim][:coop_member_id])
    end

    begin

      respond_to do |format|
        if @process_claim.save!
          pt = Claims::ProcessTrack.create(route_id: 2, user: current_user, trackable: @process_claim)
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
    # raise "errors"
    @claim_track = @process_claim.process_tracks.build
    @claim_track.route_id = params[:p]
    unless params[:s].nil?
      @claim_track.status = params[:s].to_i
      unless @claim_track.reconsider?
        @claim_track.route_id = approver_routes(@process_claim,@claims_user_authority_level.maxAmount, @claim_track.status)
        if @process_claim.check_authority_level(@claims_user_authority_level.maxAmount)
          @process_claim.update(status: :denied) if @claim_track.denied?
          @process_claim.update(status: :approved) if @claim_track.approved?
          @process_claim.update(status: :pending) if @claim_track.pending?
        end
        unless @claims_user_reconsider.nil?
          if @process_claim.check_authority_level(@claims_user_reconsider.maxAmount)
            @process_claim.update(status: :reconsider_denied) if @claim_track.reconsider_denied?
            @process_claim.update(status: :reconsider_approved, approval: 1) if @claim_track.reconsider_approved?
          end
        end
      else
        @claim_track.route_id = 10 if @process_claim.claim_review?
        @process_claim.update!(status: :reconsider)
      end
    end
    @claim_track.user_id = current_user.id
    # raise "errors"
    #CHECK THE ATTACH DOCUMENTS
    # unless current_user.userable_type == "Employee"
      if @process_claim.coop_file? || @process_claim.analyst_file? || @process_claim.incomplete_document?
        document_status = @process_claim.attach_document_status
        @status_message = document_status[:status_message]
        status = document_status[:status]
        return redirect_to show_coop_claims_process_claim_path(@process_claim), alert: @status_message if status && current_user.userable_type == "CoopUser"
        return redirect_to claim_process_claims_process_claim_path(@process_claim), alert: @status_message if status && current_user.userable_type == "Employee"
      end
    # end


    # raise "errors"
    respond_to do |format|
      if @claim_track.save
        unless @claim_track.reconsider?
            case @claim_track.route_id
            when 1
              @process_claim.update!(claim_route: @claim_track.route_id, status: :filing, claim_filed: 0, processing: 0, approval: 0, payment: 0)
            when 2
              import_product_benefit if @process_claim.documentation_review?
              @process_claim.update!(claim_route: @claim_track.route_id, status: :assessment, claim_filed: 1, processing: 0, approval: 0, payment: 0)
            when 3
              @process_claim.update!(claim_route: @claim_track.route_id, status: :process, processing: 1)
            when 4
              @process_claim.update!(claim_route: @claim_track.route_id, user_id: current_user)
            when 8
              @process_claim.update!(claim_route: @claim_track.route_id, status: :approved, payment: 1)
              ActiveRecord::Base.transaction do
                @process_claim.update!(claim_route: @claim_track.route_id, status: :approved, approval: 1)

                if @process_claim.voucher_requests&.last&.vouchers&.pending_audit.present?
                  #* put the check voucher to pending here
                  @process_claim.voucher_request.vouchers.pending_audit.last.update(audit: :for_audit)
                else
                  account_id = process_claim_params[:coop_bank] if params[:pt] == 'debit_advice'
                  request = VoucherRequestService.new(@process_claim, @process_claim.get_benefit_claim_total, :claims_payment, current_user, params[:pt].to_sym, account_id)

                  if request.create_request
                    format.html { redirect_to claims_process_claims_path(@process_claim), notice: "#{@process_claim.claim_route.to_s.humanize.titleize} status"  }
                  else
                    format.html { redirect_to claim_process_claims_process_claim_path(@process_claim), alert: "Something went wrong" }
                  end
                end
              end
            when 18
              @process_claim.update!(claim_route: @claim_track.route_id, status: :denied_due_to_non_compliance)
            when 19
              @process_claim.update!(claim_route: @claim_track.route_id, status: :pending)
            when 24
              @process_claim.update!(claim_route: @claim_track.route_id, status: :pending)
              return redirect_to edit_ca_claims_process_claim_path(@process_claim)
            else
              @process_claim.update!(claim_route: @claim_track.route_id)
            end
        end

        if current_user.userable_type == "Employee"
          return redirect_to claim_process_claims_process_claim_path(@process_claim), notice: "#{@process_claim.claim_route.to_s.humanize.titleize} status"
        else
          return redirect_to show_coop_claims_process_claim_path(@process_claim), notice: "#{@process_claim.claim_route.to_s.humanize.titleize} status"
        end
      end
    end
  end

  def import_product_benefit
    if @process_claim.claim_type == Claims::ClaimType.find_by(name: "Hospital Confinement Claim")
      @benefit = Benefit.find_by(name: "Hospital Income Benefit")
      @process_claim.claim_benefits.create(process_claim_id: @process_claim.id, benefit: @benefit, amount: @process_claim.claim_confinements.sum(:amount))
    else
      @product_benefit = ProductBenefit.where(agreement_benefit: @process_claim.agreement_benefit)
      @product_benefit.each do | pb |
        @process_claim.claim_benefits.create(process_claim_id: @process_claim.id, benefit_id: pb.benefit_id, amount: pb.coverage_amount)
      end
    end
    @batch = Batch.where(coop_member: @process_claim.coop_member, agreement_benefit: @process_claim.agreement_benefit)
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
        redirect_to index_show_claims_process_claims_path(p: 2), notice: "Process claim was successfully updated."
      else
        redirect_to index_show_process_claims_path(p: 3), notice: "Process claim was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit_coop
  end

  def update_coop
    if @process_claim.update(process_claim_params)
      if @process_claim.coop_file?
        redirect_to show_coop_claims_process_claim_path(@process_claim), notice: "Process claim was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /process_claims/1
  def destroy
    @coop_member = @process_claim.coop_member

    @process_claim.destroy
    redirect_to show_insurance_coop_member_path(@coop_member), alert: "Claim cancelled"
  end

  def claims_dashboard
    @user_levels = current_user.user_levels.where(active: 1) if current_user
    @for_evaluation = Claims::ProcessClaim.where(claim_route: get_route_evaluators) if current_user.userable_type == "Employee"
    # unless @claims_user_authority_level == "Claims Evaluator" ||  @claims_user_authority_level == "COSO (Approver)" || @claims_user_authority_level == "President (Approver)"
    #   @for_evaluation = Claims::ProcessClaim.where(claim_route: 3)
    # end
    @coop_messages = Claims::ClaimRemark.where(coop: 1)
    @process_claims = Claims::ProcessClaim.all
    # end
    # raise "errors"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_process_claim
    @process_claim = Claims::ProcessClaim.find(params[:id])
    @loan_batch = @process_claim.loan_batch if @process_claim.loan_batch.present?

  end

  # Only allow a list of trusted parameters through.
  def process_claim_params
    params.require(:claims_process_claim).permit(:coop_bank, :claim_retrieval_id, :claim_type_nature_id, :cooperative_id, :coop_member_id, :claim_route, :agreement_id, :agreement_benefit_id, :batch_id, :coop_member_id, :cause_id, :claim_type_id, :date_file, :claim_filed, :processing, :approval, :payment, :coop_member_type, :date_incident, :entry_type, :claimant_name, :claimant_email, :claimant_contact_no, :nature_of_claim, :agreement_benefit_id, :relationship, :old_code, :user_id, :insurable,
      claim_documents_attributes: [:id, :document, :document_type, :_destroy],
      process_tracks_attributes: [:id, :description, :route_id, :trackable_type, :trackable_id ],
      claim_benefits_param: [:id, :benefit_id, :amount, :status],
      claim_cause_attributes: [:id, :acd, :ucd, :osccd, :icd, :postmortem, :cause_of_incident],
      claim_coverage_attributes: [:id, :amount_benefit, :coverage_type, :coverageale],
      claim_remark_attributes: [:id, :user_id, :status, :remark, :coop, :read],
      claim_attachment_attributes: [:id, :claim_type_id, :doc],
      claim_confinement_attributes: [:id, :date_admit, :date_discharge, :terms, :amount],
      claim_reinsurance_attributes: [:id, :status])
  end

  def set_dummy_value
    first_name = FFaker::NamePH.first_name
    @process_claim.claimant_name = first_name + " " + FFaker::NamePH.last_name
    @process_claim.claimant_contact_no = FFaker::PhoneNumber.phone_number
    @process_claim.claimant_email = first_name + "@gmail.com"
  end
end
