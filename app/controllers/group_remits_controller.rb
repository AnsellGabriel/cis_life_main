class GroupRemitsController < InheritedResources::Base
  include Container
  include Counter
  
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_group_remit, only: %i[show edit update destroy submit payment]
  before_action :set_members, only: %i[new create edit update]

  def renewal
    @group_remit = GroupRemit.find_by(id: params[:id])
    renewal_result = @group_remit.renew
    new_group_remit = renewal_result[:new_group_remit]

    respond_to do |format|
      if @group_remit.present?
        format.html { redirect_to group_remit_path(new_group_remit), notice: "Group remit renewed" }
      end
    end
  end

  def submit
    if @group_remit.batches.empty?
      respond_to do |format|
        format.html { redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), alert: "Unable to submit empty batch!" }
      end
      return
    end

    all_renewal = @group_remit.batches.all? { |batch| batch.status == "renewal" }

    if all_renewal
      @group_remit.set_for_payment_status
      @group_remit.set_batches_status_renewal
    else
      @group_remit.set_under_review_status
    end
    
    respond_to do |format|
      if @group_remit.save!
        @process_coverage = @group_remit.build_process_coverage
        @process_coverage.effectivity = @group_remit.effectivity_date
        @process_coverage.expiry = @group_remit.expiry_date
        @process_coverage.set_default_attributes
        
        if @process_coverage.save
          format.html { redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), notice: "Group remit submitted" }
        else
          format.html { redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), alert: "Process Coverage not created!" }
        end

      else
        format.html { redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), alert: "Please see members below and complete the necessary details." }
      end
    end
  end

  def index
    @agreement = Agreement.find_by(id: params[:agreement_id])
    @group_remits = @agreement.group_remits
  end

  def show
    load_data
    load_batches
    paginate_batches
  end

  def new
    @agreement = Agreement.find_by(id: params[:agreement_id])
    @group_remit = @agreement.group_remits.build(
      name: FFaker::Company.name, 
      description: FFaker::Lorem.paragraph, 
      agreement_id: 1, 
      anniversary_id: 1)
  end

  def create
    # byebug
    @agreement = Agreement.find_by(id: params[:agreement_id])
    short_term_insurance = @agreement.plan.acronym == 'PMFC'

    if short_term_insurance && params[:group_remit][:terms].blank?
      return redirect_to coop_agreement_path(@agreement), alert: 'Please select a term duration'
    end
    
    @group_remit = @agreement.group_remits.build
    anniversary_date = set_anniversary(@agreement.anniversary_type, params[:anniversary_id])
    @group_remit.set_terms_and_expiry_date(anniversary_date)
    @group_remit.type = 'Remittance'

    set_group_remit_names_and_terms(@group_remit, short_term_insurance)

    respond_to do |format|
      if @group_remit.save!

        if params[:type] == 'BatchRemit' || short_term_insurance
          batch_remit = @agreement.group_remits.build(type: 'BatchRemit')
          batch_remit.set_terms_and_expiry_date(anniversary_date)
          set_group_remit_names_and_terms(batch_remit, short_term_insurance)
            batch_remit.save!
        end
        
        format.html { redirect_to coop_agreement_group_remit_path(@agreement, @group_remit), notice: "Group remit was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @agreement = @group_remit.agreement
  end

  def update
    respond_to do |format|
      if @group_remit.update(group_remit_params)
        format.html { redirect_to @group_remit, notice: "Group remit was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    agreement = @group_remit.agreement

    respond_to do |format|
      if @group_remit.destroy!
        format.html { redirect_to coop_agreement_path(agreement), alert: "Group remit was successfully deleted." }
      end
    end
  end

  def payment
    if params[:file].nil?
      return redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), alert: "Please attach proof of payment"
    end

    agreement = @group_remit.agreement
    @group_remit.payments.build(receipt: params[:file])
    @group_remit.status = :payment_verification
    # @group_remit.effectivity_date = Date.today

    respond_to do |format|
      if @group_remit.save!
        approved_batches = @group_remit.batches.where(insurance_status: :approved)
        current_batch_remit = agreement.group_remits.find_by(type: 'BatchRemit', effectivity_date: @group_remit.effectivity_date)

        current_batch_remit.batches << approved_batches
        current_batch_remit.status = :active
        current_batch_remit.save!

        format.html { redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), notice: "Proof of payment sent" }
      else
        format.html { redirect_to coop_agreement_group_remit_path(@group_remit.agreement, @group_remit), alert: "Invalid proof of payment" }
      end
    end
  end


  private

    def set_group_remit
      @group_remit = GroupRemit.includes(:batches).find(params[:id])
    end

    def set_members
      @members = Member.coop_member_details(@cooperative.coop_members)
    end

    def group_remit_params
      params.require(:group_remit).permit(:name, :description, :agreement_id, :anniversary_id, 
        process_coverage_attributes: [:group_remit_id, :effectivity, :expiry], payments_attributes: [:id, :receipt, :_destroy] )
    end

    def set_anniversary(anniversary_type, anniv_id)
      if anniversary_type == "single" || anniversary_type == "multiple"
        anniv_date = @agreement.anniversaries.find_by(id: anniv_id)
        anniv_date.anniversary_date
      elsif (anniversary_type == "none" or anniversary_type.nil?) && @agreement.plan.acronym != 'PMFC'
        Date.today.prev_month.end_of_month.next_year
      elsif @agreement.plan.acronym == 'PMFC'
        Date.today.beginning_of_month + params[:group_remit][:terms].to_i.months
      end
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end

    def load_data
      @agreement = @group_remit.agreement
      @anniversary = @group_remit.anniversary
      load_concerns
    end

    def load_concerns
      containers # controller/concerns/container.rb
      counters  # controller/concerns/counter.rb
    end

    def load_batches
      batches_eager_loaded = @group_remit.batches.includes(
        {coop_member: :member, batch_dependents: :member_dependent, batch_beneficiaries: :member_dependent},
        :batch_health_decs,
        :agreement_benefit
      ).order(created_at: :desc)

      if params[:batch_filter].present?
        @f_batches = batches_eager_loaded.filter_by_member_name(params[:batch_filter].upcase).order(created_at: :desc)
      elsif params[:batch_beneficiary_filter].present?
        @f_batches = @group_remit.batches_without_beneficiaries.order(created_at: :desc)
      elsif params[:batch_health_dec_filter].present?
        @f_batches = @group_remit.batches_without_health_dec.order(created_at: :desc)
      elsif params[:rank_filter].present?
        @f_batches = @group_remit.batches.joins(:agreement_benefit).where(agreement_benefits: params[:rank_filter])
      else
        @f_batches = batches_eager_loaded
      end
    end

    def paginate_batches
      @pagy, @batches = pagy(@f_batches, items: 10)
    end

    def set_group_remit_names_and_terms(group_remit, short_term_insurance)
      remit_name = group_remit.type == 'BatchRemit' ? 'BATCH' : 'REMITTANCE'
      
      if short_term_insurance
        group_remit.terms = params[:group_remit][:terms]
        group_remit.name = "#{@agreement.moa_no} #{group_remit.effectivity_date.strftime('%B').upcase} #{remit_name} - #{group_remit.terms} MONTHS"
      elsif @agreement.anniversary_type == 'none' or @agreement.anniversary_type.nil?
        group_remit.name = "#{@agreement.moa_no} #{group_remit.effectivity_date.strftime('%B').upcase} #{remit_name}"
      else 
        group_remit.name = "#{@agreement.moa_no} #{remit_name}"
      end
    end
end
