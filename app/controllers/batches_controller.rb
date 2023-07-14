class BatchesController < ApplicationController
  include Container
  include Counter

  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_batch, only: %i[show edit update destroy health_dec]
  before_action :set_group_remit_and_agreement
  
  def import
    import_service = CsvImportService.new(
      :batch, 
      params[:file], 
      @cooperative, 
      @group_remit
    )

    @import_result = import_service.import
    
    if @import_result.is_a?(Hash)
      notice = "#{@import_result[:added_members_counter]} members successfully added. #{@import_result[:denied_members_counter]} members denied."
      if @import_result[:denied_members_counter] > 0
        redirect_to group_remit_denied_members_path(@group_remit), notice: notice
      else
        redirect_to group_remit_path(@group_remit), notice: notice
      end
    else
      redirect_to group_remit_path(@group_remit), notice: @import_result
    end

  end

  def health_dec
    @member = @batch.member_details
    @batch_health_dec = @batch.batch_health_decs
    @group_remit = @batch.group_remit
    @questionaires = BatchHealthDec.where(batch_id: @batch.id).where(answerable_type: "HealthDec")
    @subquestions = BatchHealthDec.where(batch_id: @batch.id).where(answerable_type: "HealthDecSubquestion")

    @for_und = params[:for_und]
    @md = params[:md]

    # Medical Director Remarks
    @batch_remark = @batch.batch_remarks.build
    @batch_status = "test"
    @batch_status = "MD"
    @rem_status = :md_reco
    @process_coverage = @batch.group_remit.process_coverage

  end

  def all_health_decs
    @group_remit = GroupRemit.find(params[:group_remit_id])
    @batches = @group_remit.batches.joins(:batch_health_decs).distinct
  end
  
  def index
    @pagy, @batches = pagy(@group_remit.batches, items: 10)
  end

  def approve_all
    @process_coverage = ProcessCoverage.find(params[:process_coverage])
    @batches = @process_coverage.group_remit.batches
    
    @batches.each do |batch|
      if batch.insurance_status == "for_review"
        # if (18..65).include?(batch.age)
        if (batch.agreement_benefit.min_age..batch.agreement_benefit.max_age).include?(batch.age)
          batch.update_attribute(:insurance_status, "approved")
          @process_coverage.increment!(:approved_count)
        end
      end
    end

    redirect_to process_coverage_path(@process_coverage), notice: "Batches have been approved!"

  end

  def show
    @batch_member = @batch.coop_member
    @effectivity_date = @batch.group_remit.effectivity_date
    @expiry_date = @batch.group_remit.expiry_date
    @beneficiaries = @batch.batch_beneficiaries
    @dependents = @batch.batch_dependents
  end

  def new
    @coop_members = @cooperative.unselected_coop_members(@group_remit.coop_member_ids)
    @batch = @group_remit.batches.new(
      effectivity_date: FFaker::Time.date, 
      expiry_date: FFaker::Time.date, 
      active: true, 
      status: :recent
    )
  end

  def create
    # raise 'errors'
    @coop_members = @cooperative.coop_member_details
    @batch = @group_remit.batches.new(batch_params)
    coop_member = @batch.coop_member

    begin
      member = coop_member.member
    rescue NoMethodError => e
      return redirect_to group_remit_path(@group_remit), alert: "Member not found"
    end

    Batch.process_batch(
      @batch, 
      @group_remit, 
      batch_params[:rank], 
      batch_params[:transferred],
      batch_params[:duration]
    )

    begin
      if member.age(@group_remit.effectivity_date) < @batch.agreement_benefit.min_age or member.age(@group_remit.effectivity_date) > @batch.agreement_benefit.max_age
        return redirect_to group_remit_path(@group_remit), alert: "Member age must be between #{@batch.agreement_benefit.min_age.to_i} and #{@batch.agreement_benefit.max_age.to_i} years old."
      else
        respond_to do |format|
          if @batch.save!
            premiums_and_commissions
            containers # controller/concerns/container.rb
            counters  # controller/concerns/counter.rb
            format.html { 
              redirect_to group_remit_path(@group_remit)
              flash[:notice] = "Member successfully added"
            }
          end
        end
      end
    rescue NoMethodError => e
      return redirect_to group_remit_path(@group_remit), alert: e.message
    rescue ActiveRecord::RecordInvalid => e
      return redirect_to group_remit_path(@group_remit), alert: e.message.gsub!(/\AValidation failed:\s?/, '')
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
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|

      if @batch.destroy
        premiums_and_commissions
        containers # controller/concerns/container.rb
        counters  # controller/concerns/counter.rb
        format.html {
          redirect_to group_remit_path(@group_remit), alert: 'Member removed'
        }
      else
        format.html {
          redirect_to group_remit_batch_path(@group_remit, @batch), alert: 'Unable to destroy batch.'
        }
      end
      
    end  
  end

  private
    def batch_params
      params.require(:batch).permit(
        :rank, 
        :duration,
        :active, 
        :coop_sf_amount, 
        :agent_sf_amount, 
        :status, 
        :premium, 
        :coop_member_id, 
        :transferred, 
        batch_dependents_attributes: [
          :member_dependent_id, 
          :beneficiary, 
          :_destroy
        ]
      )
    end

    def set_group_remit_and_agreement
      @group_remit = GroupRemit.find_by(id: params[:group_remit_id])
      @agreement = @group_remit.agreement
    end

    def set_batch
      set_group_remit_and_agreement
      @batch = @group_remit.batches.find_by(id: params[:id])
    end
    
    def premiums_and_commissions
      @gross_premium = @group_remit.gross_premium
      @total_coop_commission = @group_remit.total_coop_commissions
      @total_agent_commission = @group_remit.total_agent_commissions
      @net_premium = @group_remit.net_premium
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser' || current_user.userable_type == 'Employee'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
