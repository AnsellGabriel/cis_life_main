class BatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_batch, only: %i[show edit update destroy]
  before_action :set_group_remit, only: %i[index new create edit update show import]
  
  def import
    import_service = CsvImportService.new(params[:file], @group_remit, @cooperative)
    import_message = import_service.import

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
    @agreement = @group_remit.agreement
    @coop_members = @cooperative.unselected_coop_members(@group_remit.coop_member_ids)
    @batch = @group_remit.batches.new(effectivity_date: FFaker::Time.date, expiry_date: FFaker::Time.date, active: true, status: :recent)
  end

  def create
    @coop_members = @cooperative.coop_member_details
    @batch = @group_remit.batches.new(batch_params)
    coop_member = @batch.coop_member
    @agreement = @group_remit.agreement
    member = coop_member.member

    Batch.process_batch(@batch, member, @group_remit, batch_params[:rank], batch_params[:transferred])
    
    
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
      params.require(:batch).permit(:rank, :active, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id, :transferred, batch_dependents_attributes: [:member_dependent_id, :beneficiary, :_destroy])
    end

    def set_group_remit
      @group_remit = GroupRemit.find_by(id: params[:group_remit_id])
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

    # def file
    #   params[:file]
    # end
  
    # def redirect_with_alert(alert_message)
    #   redirect_to group_remit_path(@group_remit), alert: alert_message
    # end
  
    # def valid_csv_file?(file)
    #   file&.content_type&.end_with?("csv")
    # end
  
    # def missing_headers(file)
    #   required_headers - csv_headers(file)
    # end
  
    # def required_headers
    #   ["Active", "First Name", "Middle Name", "Last Name", "Suffix", "Status"]
    # end
  
    # def csv_headers(file)
    #   CSV.open(file.path, &:readline).map(&:strip)
    # end



end
