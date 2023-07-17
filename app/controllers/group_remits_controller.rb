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
    # byebug
  end

  def submit
    if @group_remit.batches.empty?
      respond_to do |format|
        format.html { redirect_to @group_remit, alert: "Unable to submit empty batch!" }
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
      if @group_remit.save
        # @group_remit.batches
        @process_coverage = @group_remit.build_process_coverage
        @process_coverage.effectivity = @group_remit.effectivity_date
        @process_coverage.expiry = @group_remit.expiry_date
        @process_coverage.set_default_attributes
        
        if @process_coverage.save
          format.html { redirect_to @group_remit, notice: "Group remit submitted" }
        else
          format.html { redirect_to @group_remit, alert: "Process Coverage not created!" }
        end
      else
        format.html { redirect_to @group_remit, alert: "Please see members below and complete the necessary details." }
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
    @agreement = Agreement.find_by(id: params[:agreement_id])
    @group_remit = @agreement.group_remits.build
    anniversary_date = set_anniversary(@agreement.anniversary_type, params[:anniversary_id])
    @group_remit.set_terms_and_expiry_date(anniversary_date)

    respond_to do |format|
      if @group_remit.save!
        format.html { redirect_to @group_remit, notice: "Group remit was successfully created." }
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
      if @group_remit.destroy
        format.html { redirect_to coop_agreement_path(agreement), alert: "Group remit was successfully deleted." }
      end
    end
  end

  def payment
    # byebug
    if params[:file].nil?
      return redirect_to @group_remit, alert: "Please attach proof of payment"
    end

    @group_remit.payments.build(receipt: params[:file])
    @group_remit.status = :payment_verification
    # @group_remit.effectivity_date = Date.today

    respond_to do |format|
      if @group_remit.save!
        format.html { redirect_to @group_remit, notice: "Proof of payment sent" }
      else
        format.html { redirect_to @group_remit, alert: "Invalid proof of payment" }
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
        @group_remit.anniversary = Anniversary.find_by(id: anniv_id.to_i)
        @group_remit.anniversary.anniversary_date
      elsif anniversary_type == "none" or anniversary_type.nil?
        Date.today.prev_month.end_of_month.next_year
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
end
