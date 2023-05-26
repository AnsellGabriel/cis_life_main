class BatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_cooperative, only: %i[index new create edit update show import]
  before_action :set_batch, only: %i[show edit update destroy]
  before_action :set_group_remit, only: %i[index new create edit update show import]

  def import
    #! Progress bar error, tracking session #
    # Check if a file has been uploaded
    file = params[:file]

    if file.nil?
      return redirect_to group_remit_path(@group_remit), alert: "No file uploaded"
    else
      return redirect_to group_remit_path(@group_remit), alert: "Only CSV file format please" unless file.content_type.end_with?("csv")
    end

    # Check if the file has the required headers
    required_headers = ["Active", "First Name", "Middle Name", "Last Name", "Suffix", "Status"]
    headers = CSV.open(file.path, &:readline).map(&:strip)
    missing_headers = required_headers - headers

    if missing_headers.any?
      return redirect_to group_remit_path(@group_remit), alert: "The following CSV headers are missing: #{missing_headers.join(', ')}"
    end

    # Read CSV file and parse its contents
    file = File.open(file)
    csv = CSV.parse(file, headers: true, skip_blanks: true).delete_if { |row| row.to_hash.values.all?(&:blank?) }

    if csv.count < 100
      return redirect_to group_remit_path(@group_remit), alert: "Imported members must be at least 100 for GYRT plan. Current count: #{csv.count}"
    end

    import_service = BatchImportService.new(csv, @group_remit, @cooperative)
    import_message = import_service.import_batches

    redirect_to group_remit_path(@group_remit), notice: import_message
  end
  

  def index
    # get all batches of the cooperative
    @batches = @group_remit.batches
    @pagy, @batches = pagy(@batches, items: 10)
  end

  def show
    @batch_member = @batch.coop_member
    @effectivity_date = @batch.group_remit.effectivity_date
    @expiry_date = @batch.group_remit.expiry_date 
    @beneficiaries = @batch.batch_beneficiaries
    @dependents = @batch.batch_dependents
    @agreement = @group_remit.agreement
  end

  def new
    @coop_members = @cooperative.unselected_coop_members(@group_remit.coop_member_ids)
    @batch = @group_remit.batches.new(effectivity_date: FFaker::Time.date, expiry_date: FFaker::Time.date, active: true, status: :recent)
  end

  def create
    @coop_members = @cooperative.coop_member_details
    @batch = @group_remit.batches.new(batch_params)

    agreement = @group_remit.agreement
    coop_member = @batch.coop_member
    member = coop_member.member

    if member.age < 18 or member.age > 65
      return redirect_to new_group_remit_batch_path(@group_remit), alert: "Member age must be between 18 and 65 years old."
    end

    renewal_member = agreement.coop_members.find_by(id: coop_member.id)

    if renewal_member.present?
        @batch.status = :renewal
    else
      if batch_params[:transferred].to_i == 1 # temporary checker for transferred members
        @batch.status = :renewal
        
      else
        @batch.status = :recent
      end
      agreement.coop_members << coop_member
    end

    if agreement.plan.acronym == 'GYRT' || agreement.plan.acronym == 'GYRTF'
      @batch.set_premium_and_service_fees(1)
    end
    
    respond_to do |format|
      if @batch.save!
        set_premiums
        # format.turbo_stream
        format.html { 
          redirect_to group_remit_path(@group_remit)
        }
        format.turbo_stream { flash.now[:notice] = "Member successfully added." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end

  end

  def edit
    @coop_members = @cooperative.coop_member_details
  end

  def update

    respond_to do |format|
      if @batch.update(batch_params)
        format.html { 
          redirect_to group_remit_path(@group_remit), notice: "Batch updated"
        }
        # format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    
    respond_to do |format|
      if @batch.destroy
        set_premiums
        format.html {
          redirect_to group_remit_path(@group_remit), alert: 'Batch was successfully destroyed.'
        }
        # format.turbo_stream { flash.now[:alert] = "Member removed" }
      else
        format.html {
          redirect_to group_remit_batch_path(@group_remit, @batch), alert: 'Unable to destroy batch.'
        }
      end
    end  
  end

  private
    def batch_params
      params.require(:batch).permit(:active, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id, :transferred, batch_dependents_attributes: [:member_dependent_id, :beneficiary, :_destroy])
    end

    def set_group_remit
      @group_remit = GroupRemit.find_by(id: params[:group_remit_id])
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end

    def set_batch
      set_group_remit
      @batch = @group_remit.batches.find_by(id: params[:id])
    end

    def set_premiums
      @agreement = @group_remit.agreement
      @batch_count = @group_remit.batches.count
      @batches_container = @group_remit.batches.order(created_at: :desc)
      @batches_dependents= BatchDependent.joins(batch: :group_remit)
        .where(group_remits: {id: @group_remit.id})

      # premium and commission totals
      @gross_premium = @group_remit.gross_premium
      @total_coop_commission = @group_remit.total_coop_commissions
      @total_agent_commission = @group_remit.total_agent_commissions
      @net_premium = @group_remit.net_premium

      @principal_count = @batches_container.count
      @dependent_count = @batches_dependents.count
      @single_premium = @batches_container[0].premium if @batches_container[0].present?
      @single_dependent_premium = @batches_dependents[0].premium if @batches_dependents[0].present?
      @batch_without_beneficiaries_count = @group_remit.batches.where.not(id: @group_remit.batches.joins(:batch_beneficiaries).select(:id)).count
      @batch_without_batch_health_dec_count = @group_remit.batches.where(status: :recent).where.not(id: @group_remit.batches.joins(:batch_health_dec).select(:id)).count
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
