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
      @group_remit,
      current_user
    )

    @import_result = import_service.import

    if @import_result.is_a?(Hash)
      added_members_count = @import_result[:added_members_counter]
      denied_members_count = @import_result[:denied_members_counter]
      added_dependents_count = @import_result[:added_dependents_counter]
      denied_dependents_count = @import_result[:denied_dependents_counter]

      added_members_message = "<li>#{added_members_count} members added</li>" if added_members_count > 0
      denied_members_message = "<li>#{denied_members_count} members denied</li>" if denied_members_count > 0
      added_dependents_message = "<li>#{added_dependents_count} dependents added</li>" if added_dependents_count > 0
      denied_dependents_message = "<li>#{denied_dependents_count} dependents denied</li>" if denied_dependents_count > 0

      notice = [added_members_message, added_dependents_message, denied_members_message, denied_dependents_message].compact.join("")
      redirect_to group_remit_path(@group_remit), notice: notice
    else
      redirect_to group_remit_path(@group_remit), alert: @import_result
    end
  end

  def health_dec
    @batch = case params[:batch_type]
            when "LoanInsurance::Batch"
              LoanInsurance::Batch.find(params[:id])
            else
              Batch.find(params[:id])
             end

    @pagy, @batch_remarks = pagy(@batch.remarks, items: 2, params: { active_tab: "stars" })

    @member = @batch.member_details
    @batch_health_dec = @batch.health_declaration
    @group_remit = GroupRemit.find(params[:group_remit_id]).decorate
    @questionaires = BatchHealthDec.where(healthdecable: @batch).where(answerable_type: "HealthDec")
    @subquestions = BatchHealthDec.where(healthdecable: @batch).where(answerable_type: "HealthDecSubquestion")

    @for_und = params[:for_und]
    @md = params[:md]
    # Medical Director Remarks
    @batch_remark = @batch.batch_remarks.build
    # @batch_status = "test"
    @batch_status = "MD"
    @rem_status = :md_reco
    # @process_coverage = @batch.group_remit.process_coverage
    @process_coverage = @group_remit.process_coverage
  end

  def all_health_decs
    @group_remit = GroupRemit.find(params[:group_remit_id])
    @batches_o = @group_remit.batches
    # @batches = case @batches_o.first.class.name
    # when "LoanInsurance::Batch"
    #   @group_remit.loan_batches.joins(:batch_health_decs).distinct
    # else
    #   @group_remit.batches.joins(:batch_health_decs).distinct
    # end
    @batches = @group_remit.batches.joins(:batch_health_decs).distinct
  end

  def index
    @pagy, @batches = pagy(@group_remit.batches, items: 10)
  end

  def approve_all
    @process_coverage = ProcessCoverage.find(params[:process_coverage])
    @batches = @process_coverage.group_remit.batches
    approved_count = 0
    for_approved_count = 0

    @batches.each do |batch|

      if batch.insurance_status == "for_review" || batch.insurance_status == "pending"
        for_approved_count += 1
        # if (18..65).include?(batch.age)
        if (batch.agreement_benefit.min_age..batch.agreement_benefit.max_age).include?(batch.age)
          if batch.valid_health_dec
            # batch.update_attribute(:insurance_status, "approved") if batch.valid_health_dec
            batch.update_attribute(:insurance_status, "approved")
            @process_coverage.increment!(:approved_count)
            approved_count += 1
          end
        end
      end
    end

    if approved_count == for_approved_count
      redirect_to process_coverage_path(@process_coverage), notice: "All batches have been approved!"
    elsif approved_count < for_approved_count && approved_count > 0
      redirect_to process_coverage_path(@process_coverage), notice: "#{approved_count} batch(es) have been approved!"
    else
      redirect_to process_coverage_path(@process_coverage), alert: "No batches have been approved!"
    end

  end

  def show
    group_remit = @batch.group_remits[0]
    @batch_member = @batch.coop_member
    @effectivity_date = group_remit.effectivity_date
    @expiry_date = group_remit.expiry_date
    @beneficiaries = @batch.batch_beneficiaries
    @dependents = @batch.batch_dependents
  end

  def new
    @coop_members = @cooperative.unselected_coop_members(@agreement.group_remits.joins(:batches).pluck(:coop_member_id))

    if Rails.env.development?
      @batch = @group_remit.batches.new(
        effectivity_date: FFaker::Time.date ,
        expiry_date: FFaker::Time.date,
        active: true,
        status: :recent
      )
    else
      @batch = @group_remit.batches.new
    end

  end

  def create
    if @agreement.plan.acronym == "GYRTFR" && params[:batch][:rank].empty?
      return redirect_to group_remit_path(@group_remit), alert: "Rank is required"
    end

    @coop_members = @cooperative.coop_member_details
    @batch = @group_remit.batches.new(batch_params)
    coop_member = @batch.coop_member

    begin
      member = coop_member.member
    rescue NoMethodError => e # if member is not found
      return redirect_to group_remit_path(@group_remit), alert: "Member not found"
    end

    Batch.process_batch(
      @batch,
      @group_remit,
      batch_params[:rank]
    )

    begin

      if member.age(@group_remit.effectivity_date) < @batch.agreement_benefit.min_age or member.age(@group_remit.effectivity_date) > @batch.agreement_benefit.max_age

        # return redirect_to group_remit_path(@group_remit), alert: "Member age must be between #{@batch.agreement_benefit.min_age.to_i} and #{@batch.agreement_benefit.max_age.to_i} years old."
        @batch.insurance_status = :denied
        if member.age(@group_remit.effectivity_date) > @batch.agreement_benefit.max_age
          @batch.batch_remarks.build(remark: "Member age is over the maximum age limit of the plan.", status: :denied, user_type: current_user.userable_type, user_id: current_user.userable.id)
        else
          @batch.batch_remarks.build(remark: "Member age is below the minimum age limit of the plan.", status: :denied, user_type: current_user.userable_type, user_id: current_user.userable.id)
        end
      end

      # raise 'errors'
      respond_to do |format|
        if @batch.save!
          @group_remit.batches << @batch

          premiums_and_commissions
          containers # controller/concerns/container.rb
          counters  # controller/concerns/counter.rb

          format.html {
            redirect_to group_remit_path(@group_remit)
            if @batch.denied?
              flash[:alert] = "Member denied. Please check the denied remarks."
            else
              flash[:notice] = "Member successfully added."
            end
          }
        end
      end
    rescue NoMethodError => e
      return redirect_to group_remit_path(@group_remit), alert: e# .message
    rescue ActiveRecord::RecordInvalid => e
      return redirect_to group_remit_path(@group_remit), alert: e# .message.gsub!(/\AValidation failed:\s?/, '')
    end

  end

  def edit
    # @coop_members = @cooperative.coop_member_details

  end

  def update
    @batch.manual_premium_and_fees(batch_params[:premium], @group_remit)

    respond_to do |format|
      if @batch.save!

        format.html {
          redirect_to coop_agreement_group_remit_path(@agreement, @group_remit), notice: "Premium updated"
        }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    agreement = @batch.group_remits[0].agreement
    coop_member = @batch.coop_member
    agreement_member = agreement.agreements_coop_members.find_by(coop_member_id: coop_member.id)

    @batch.batch_group_remits.destroy_all
    agreement.coop_members.delete(coop_member) if @batch.recent?
    respond_to do |format|

      if @batch.destroy

        if params[:reconsider].present? && params[:reconsider]
          @group_remit.process_coverage.update(status: :reconsiderations_processed)
        end

        premiums_and_commissions
        containers # controller/concerns/container.rb
        counters  # controller/concerns/counter.rb
        # delete_associated_batches
        format.html {
          redirect_to group_remit_path(@group_remit), alert: "Member removed"
        }
      else
        format.html {
          redirect_to group_remit_batch_path(@group_remit, @batch), alert: "Unable to destroy batch."
        }
      end

    end
  end

  def modal_remarks
    @batch = Batch.find(params[:id])
  end

  # def terminate_insurance

  # end

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
    unless current_user.userable_type == "CoopUser" || current_user.userable_type == "Employee"
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  def delete_associated_batches
    agreement = @batch.group_remits[0].agreement
    coop_member = @batch.coop_member
    agreement.coop_members.delete(coop_member) if @batch.status == "recent"
    @batch.batch_group_remits.destroy_all
  end

end
