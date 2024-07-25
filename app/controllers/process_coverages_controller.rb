class ProcessCoveragesController < ApplicationController
  include CsvGenerator

  before_action :authenticate_user!
  before_action :check_emp_department, except: :modal_remarks
  before_action :set_process_coverage,
  only: %i[ show edit update destroy approve_batch deny_batch pending_batch reconsider_batch pdf set_premium_batch update_batch_prem transfer_to_md update_batch_cov adjust_lppi_cov refund psheet set_processor set_processor]

  # GET /process_coverages
  def index
    @arel_pcs = ProcessCoverage.arel_table
    if current_user.rank == "senior_officer"

      @process_coverages_x = ProcessCoverage.all
      @for_process_coverages = ProcessCoverage.where(status: :for_process)
      @approved_process_coverages = ProcessCoverage.where(status: :approved)
      @reprocess_coverages = ProcessCoverage.where(status: :reprocess)
      @reassess_coverages = ProcessCoverage.where(status: :reassess)
      @denied_process_coverages = ProcessCoverage.where(status: :denied)

      @coverages_total_processed = ProcessCoverage.where(status: [:approved, :denied, :reprocess])

      if params[:search].present?
        @process_coverages = @process_coverages_x.joins(group_remit: {agreement: :cooperative}).where(
        "group_remits.name LIKE ? OR group_remits.description LIKE ? OR agreements.moa_no LIKE ? OR cooperatives.name LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
      else
        @process_coverages = @process_coverages_x
      end

      if params[:emp_id].present?
        # raise 'errors'
        date_from = Date.strptime(params[:date_from], "%m-%d-%Y")
        date_to = Date.strptime(params[:date_to], "%m-%d-%Y")
        @process_coverages = @process_coverages_x.where(processor_id: params[:emp_id], status: :for_process, created_at: date_from..date_to)
      end

    elsif current_user.rank == "head"

      @overall_coverages = ProcessCoverage.where(team: current_user.userable.team)
      @approved_coverages = @overall_coverages.where(status: :approved)
      @denied_coverages = @overall_coverages.where(status: :denied)
      @on_process_coverages = @overall_coverages.where(status: :for_process)

      @process_coverages_x = ProcessCoverage.all
      @for_process_coverages = @process_coverages_x.where(status: :for_process)
      @approved_process_coverages = @process_coverages_x.where(status: :approved)
      # @pending_process_coverages = ProcessCoverage.where(status: :pending)
      @reprocess_coverages = @process_coverages_x.where(status: :reprocess)
      @reassess_coverages = @process_coverages_x.where(status: :reassess)
      @denied_process_coverages = @process_coverages_x.where(status: :denied)

      @coverages_total_processed = ProcessCoverage.where(status: [:approved, :denied, :reprocess])
      
      if params[:search].present?
        @process_coverages = @process_coverages_x.joins(group_remit: {agreement: :cooperative}).where(
        "group_remits.name LIKE ? OR group_remits.description LIKE ? OR agreements.moa_no LIKE ? OR cooperatives.name LIKE ? OR cooperatives.acronym LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
      else
        @process_coverages = @process_coverages_x
      end

      if params[:emp_id].present?
        date_from = Date.strptime(params[:date_from], "%m-%d-%Y")
        date_to = Date.strptime(params[:date_to], "%m-%d-%Y")
        # @process_coverages = @process_coverages_x.where(processor_id: params[:emp_id], status: params[:process_type], created_at: params[:date_from]..params[:date_to])
        @process_coverages = @process_coverages_x.where(processor_id: params[:emp_id], status: params[:process_type], created_at: date_from..date_to)
      end

    elsif current_user.analyst?
      # @process_coverages_x = ProcessCoverage.joins(group_remit: { agreement: :plan, batches: {} }).where(team: current_user.userable.team)
      @process_coverages_team = ProcessCoverage.joins(group_remit: { agreement: :plan }).where(team: current_user.userable.team)
      @self_process_coverages = ProcessCoverage.joins(group_remit: { agreement: :plan }).where(processor: current_user.userable)
      @for_process_coverages = @process_coverages_team.where(status: :for_process, processor: nil)
      # @for_process_coverages = @process_coverages_x.where(processor: nil)
      # @approved_process_coverages = @process_coverages_x.where(status: :approved, who_approved: current_user.userable)
      @approved_process_coverages = @process_coverages_team.where(status: :approved).where(@arel_pcs[:who_approved_id].eq(current_user.userable_id).or(@arel_pcs[:who_processed_id].eq(current_user.userable_id).and(@arel_pcs[:who_approved_id].not_eq(nil))))
      # @pending_process_coverages = ProcessCoverage.where(status: :pending)
      @reprocess_coverages = @process_coverages_team.where(status: :reprocess)
      @reassess_coverages = @process_coverages_team.where(status: :reassess)
      @denied_process_coverages = @process_coverages_team.where(status: :denied)
      @evaluated_process_coverages = @process_coverages_team.where(status: [:for_head_approval, :for_vp_approval])
      @selected_process_coverages = @process_coverages_team.where(processor: current_user.userable, status: [:pending, :for_process])

      @coverages_total_processed = ProcessCoverage.where(status: [:approved, :denied, :reprocess])

      @process_coverages_x = @self_process_coverages

      @md_reviewed= 0 

      @for_md_review = 0
      @reviewed_batch = []
      @for_review_batch = []
      @lppi_batches = LoanInsurance::Batch.includes(group_remit: :process_coverage).where(process_coverages: { team: current_user.userable.team}, substandard: true, for_md: true).sort_by do |batch|
        md = User.find_by(rank: :medical_director)
        if batch.batch_remarks.where(user: md.userable).count > 0
          @md_reviewed += 1
          @reviewed_batch << batch
        else
          @for_md_review += 1
          @for_review_batch << batch
        end
      end
      # @for_md_review = LoanInsurance::Batch.includes(group_remit: :process_coverage).where(process_coverages: { team: current_user.userable.team}, substandard: true)

      # @md_reviewed = LoanInsurance::Batch.includes(group_remit: :process_coverage).includes(:batch_remarks).where(process_coverages: { team: current_user.userable.team}, substandard: true)

      if params[:search].present?
        @process_coverages = @process_coverages_x.joins("INNER JOIN cooperatives ON cooperatives.id = agreements.cooperative_id").where(
        "group_remits.name LIKE ? OR group_remits.description LIKE ? OR agreements.moa_no LIKE ? OR cooperatives.name LIKE ? OR agreements.description LIKE ? OR plans.name LIKE ? OR plans.acronym LIKE ? OR cooperatives.acronym LIKE ? OR group_remits.official_receipt LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
      else
        @process_coverages = @process_coverages_x
      end

      if params[:emp_id].present?
         # date_from = Date.strptime(params[:date_from], "%m-%d-%Y")
         date_from = Date.strptime(params[:date_from], "%Y-%m-%d")
         # date_to = Date.strptime(params[:date_to], "%m-%d-%Y")
         date_to = Date.strptime(params[:date_to], "%Y-%m-%d")
        @process_coverages = @process_coverages_x.where(status: params[:process_type], created_at: params[:date_from]..params[:date_to])
      end

    else
      @process_coverages_x = ProcessCoverage.all
    end

    @analysts_x = Employee::ANALYSTS
    if current_user.senior_officer?
      @analysts = @analysts_x.joins(:emp_approver)
    elsif current_user.head?
      @analysts = @analysts_x.joins(:emp_approver)
      # @analysts = @analysts_x.joins(:emp_approver).where(emp_approver: { approver: current_user.userable_id })
    end
    
    @pagy_pc, @filtered_pc = pagy(@process_coverages.order(@arel_pcs[:processor_id].eq(current_user.userable_id).desc), items: 5, page_param: :process_coverage, link_extra: 'data-turbo-frame="pro_cov_pagination"')
    @notifications = current_user.userable.team.notifications.where(created_at: @current_date.beginning_of_week..@current_date.end_of_week)
    # if params[:search].present?
    #   @process_coverages = @process_coverages_x.joins(group_remit: {agreement: :cooperative}).where("group_remits.name LIKE ? OR group_remits.description LIKE ? OR agreements.moa_no LIKE ? OR cooperatives.name LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    # else
    #   @process_coverages = @process_coverages_x
    # endx``
  end

  def substandard_batches
    @md_reviewed = 0
    @for_md_review = 0
    @reviewed_batches = []
    @for_review_batches = []
    @lppi_batches = LoanInsurance::Batch.includes(group_remit: :process_coverage).where(process_coverages: { team: current_user.userable.team}, substandard: true, for_md: true).sort_by do |batch|
      md = User.find_by(rank: :medical_director)
      if batch.batch_remarks.where(user: md.userable).count > 0
        @md_reviewed += 1
        @reviewed_batches << batch
      else
        @for_md_review += 1
        @for_review_batches << batch
      end
    end

    case params[:type]
    when "md"
      @title = "For M.D. Review"
      @batches = @for_review_batches
    else
      @title = "M.D. Reviewed Coverages"
      @batches = @reviewed_batches
    end

  end

  def download
    pdf = Prawn::Document.new
    pdf.text "Hello World"
    send_data(pdf.render,
      filename: "hello.pdf",
      type: "application/pdf")
  end

  def gen_csv

  end

  def product_csv

    date_from = Date.strptime(params[:date_from], "%m-%d-%Y")
    date_to = Date.strptime(params[:date_to], "%m-%d-%Y")

    case params[:emp_id]
    when "0" then
      emp = "PROCESS COVERAGES"
      @process_coverages = ProcessCoverage.get_reports(params[:process_type].to_i, date_from, date_to)
    else
      emp = Employee.find(params[:emp_id])
      @process_coverages = ProcessCoverage.where(processor_id: params[:emp_id], status: params[:process_type], created_at: date_from..date_to).order(:created_at)
    end

    if @process_coverages.nil? || @process_coverages.empty?
      redirect_back fallback_location: process_coverages_path, alert: "No record(s) found."
    else
      generate_csv(@process_coverages, "#{emp} - #{date_from} to #{date_to}")
    end
  end

  def pdf
    @batches_x = @process_coverage.group_remit.batches
    @total_life_cov = case @process_coverage.get_plan_acronym
    when "LPPI"
      @process_coverage.group_remit.total_loan_amount
    else
      ProductBenefit.joins(agreement_benefit: :batches).where("batches.id IN (?)", @batches_x.pluck(:id)).where(batches: { insurance_status: :approved }).where("product_benefits.benefit_id = ?", 1).sum(:coverage_amount)
    end

    pdf = PsheetPdf.new(@process_coverage, @total_life_cov, view_context)
    # pdf = SheetPdf.new(@process_coverage, @total_life_cov, view_context)
    send_data(pdf.render,
      filename: "#{@process_coverage.group_remit.agreement.plan.acronym}-#{@process_coverage.group_remit.name}.pdf",
      type: "application/pdf",
      disposition: "inline")
  end

  def und
    @notifications = current_user.userable.notifications
    @process_coverages = ProcessCoverage.all
    @pagy_pc, @filtered_pc = pagy(@process_coverages, items: 5, page_param: :process_coverage, link_extra: 'data-turbo-frame="pro_cov_pagination"')
  end

  def set_processor
    respond_to do |format|
      if @process_coverage.processor.nil?
        @process_coverage.update(processor: current_user.userable, approver: current_user.userable.get_approver)
        format.html { redirect_to @process_coverage, notice: "Processor has been set." }
      else
        format.html { redirect_to @process_coverage }
      end

    end
  end


  def cov_list
    # raise 'errors'
    @current_date = params[:current_date]&.to_date

    if params[:date_type] == "yearly"
      start_date = @current_date.beginning_of_year
      end_date = @current_date.end_of_year
    elsif params[:date_type] == "monthly"
      start_date = @current_date.beginning_of_month
      end_date = @current_date.end_of_month
    elsif params[:date_type] == "weekly"
      start_date = @current_date.beginning_of_week
      end_date = @current_date.end_of_week
    end

    @process_coverages = case params[:cov_type]
      when "For Process"
        # ProcessCoverage.where(status: :for_process, created_at: start_date..end_date)
        if current_user.head?
          # ProcessCoverage.joins(group_remit: { agreement: { emp_agreements: {employee: :emp_approver} } }).where( emp_approver: { approver_id: current_user.userable_id }, emp_agreements: { active: true}).where(status: :for_process, created_at: start_date..end_date)
          ProcessCoverage.index_cov_list(current_user.userable_id, :for_process, start_date..end_date)
        elsif current_user.senior_officer?
          ProcessCoverage.where(status: :for_process, created_at: start_date..end_date)
        elsif current_user.analyst?
          ProcessCoverage.cov_list_analyst(current_user.userable, :for_process)
        end

      when "Evaluated"
        if current_user.analyst?
          ProcessCoverage.cov_list_analyst(current_user.userable, "", "eval")
        end

      when "Selected"
        if current_user.analyst?
          ProcessCoverage.cov_list_analyst(current_user.userable, "", "selected")
        end

      when "Processed"
        if current_user.analyst?
          ProcessCoverage.cov_list_analyst(current_user.userable, "", "process")
        end

      when "Denied"
        if current_user.analyst?
          ProcessCoverage.cov_list_analyst(current_user.userable, "", "denied")
        end

      when "Approved"
        # ProcessCoverage.where(status: :approved, created_at: start_date..end_date)
        if current_user.head?
          ProcessCoverage.index_cov_list(current_user.userable_id, :approved, start_date..end_date)
          # ProcessCoverage.joins(group_remit: { agreement: { emp_agreements: {employee: :emp_approver} } }).where( emp_approver: { approver_id: current_user.userable_id }, emp_agreements: { active: true}).where(status: :approved, created_at: start_date..end_date)
        elsif current_user.senior_officer?
          ProcessCoverage.where(status: :approved, created_at: start_date..end_date)
        elsif current_user.analyst?
          ProcessCoverage.cov_list_analyst(current_user.userable, "", "approved")
        end

      when "Reconsider"
        # ProcessCoverage.where(status: :for_reconsider, created_at: start_date..end_date)
        if current_user.head?
          ProcessCoverage.index_cov_list(current_user.userable_id, :reprocess, start_date..end_date)
          # ProcessCoverage.joins(group_remit: { agreement: { emp_agreements: {employee: :emp_approver} } }).where( emp_approver: { approver_id: current_user.userable_id }, emp_agreements: { active: true}).where(status: :reprocess, created_at: start_date..end_date)
        elsif current_user.senior_officer?
          ProcessCoverage.where(status: :reprocess, created_at: start_date..end_date)
        end

      when "Reassess"

        # ProcessCoverage.where(status: :for_reconsider, created_at: start_date..end_date)
        if current_user.head?
          ProcessCoverage.index_cov_list(current_user.userable_id, :reassess, start_date..end_date)
          # ProcessCoverage.joins(group_remit: { agreement: { emp_agreements: {employee: :emp_approver} } }).where( emp_approver: { approver_id: current_user.userable_id }, emp_agreements: { active: true}).where(status: :reassess, created_at: start_date..end_date)
        elsif current_user.senior_officer?
          ProcessCoverage.where(status: :reassess, created_at: start_date..end_date)
        end

      when "Denied"
        if current_user.head?
          ProcessCoverage.index_cov_list(current_user.userable_id, :denied, start_date..end_date)
          # ProcessCoverage.joins(group_remit: { agreement: { emp_agreements: {employee: :emp_approver} } }).where( emp_approver: { approver_id: current_user.userable_id }, emp_agreements: { active: true}).where(status: :denied, created_at: start_date..end_date)
        elsif current_user.senior_officer?
          ProcessCoverage.where(status: :denied, created_at: start_date..end_date)
        end
      when "head approval" then ProcessCoverage.for_head_approvals(current_user) #(current_user, current_user.userable_id)# where(status: :for_head_approval)
      when "vp approval" then ProcessCoverage.for_vp_approvals(current_user) #(current_user, current_user.userable_id)# where(status: :for_head_approval)
                         end

    @title = params[:title]

    @pagy_pc, @filtered_pc = pagy(@process_coverages, items: 5, page_param: :process_coverage, link_extra: 'data-turbo-frame="cov_list_pagination"')

  end

  def update_batch_selected
    # raise 'errors'
    @pro_cov = ProcessCoverage.find_by(id: params[:p_id])
    ids = params[:b_ids]

    respond_to do |format|
      if ids.nil?
        format.html { redirect_to process_coverage_path(@pro_cov), alert: "Please select batch(es) to update!" }
        # redirect_back fallback_location: @pro_cov, alert: "Please select batch(es) to update!"
      else

        if params[:approve]
          case @pro_cov.get_batch_class_name
          when "LoanInsurance::Batch"
            LoanInsurance::Batch.where(id: ids).update_all(insurance_status: :approved)
          else
            Batch.where(id: ids).update_all(insurance_status: :approved)
          end

          @pro_cov.increment!(:approved_count, ids.length)
          # redirect_to process_coverage_path(@pro_cov), notice: "Selected Coverages Approved!"
          format.html { redirect_back fallback_location: @pro_cov, notice: "Selected Coverages Approved!" }

        elsif params[:deny]
          case @pro_cov.get_batch_class_name
          when "LoanInsurance::Batch"
            LoanInsurance::Batch.where(id: ids).update_all(insurance_status: :denied)
          else
            Batch.where(id: ids).update_all(insurance_status: :denied)
          end

          @pro_cov.increment!(:denied_count, ids.length)
          # redirect_to process_coverage_path(@pro_cov), alert: "Selected Coverages Denied!"
          format.html { redirect_back fallback_location: @pro_cov, notice: "Selected Coverages Denied!" }
        end

      end
    end


    # redirect_to process_coverage_path(@process_coverage), notice: "Selected Coverages Approved!"
  end

  # GET /process_coverages/1
  def show
    @plan = @process_coverage.get_plan
    if ["LPPI","SII"].include?(@plan.acronym)
      @batches_o = @process_coverage.group_remit.batches
      if params[:search].present?
        @batches = case params[:search]
        when "regular_new" then @batches_o.where(age: 18..65, status: 0)
        when "regular_ren" then @batches_o.where(age: 18..65, status: 1..2)
        when "overage" then @batches_o.where(age: 66..)
        when "reconsider" then @batches_o.where(status: :for_reconsideration)
        when "substandard" then @batches_o.where(substandard: true)
          # when "health_decs" then @batches_o.joins(:batch_health_decs)
        when "health_decs" then @batches_o.joins(:batch_health_decs).where(loan_insurance_batches: { valid_health_dec: false }).distinct
                     # when "health_decs" then @batches_o.joins(:batch_health_dec).where.not(batch_health_decs: { health_dec_question_id: nil })
                   end
      else
        @batches = @batches_o
      end

      if params[:search_member].present?
        @batches = @batches_o.joins(coop_member: :member).where("members.last_name LIKE ? OR members.first_name LIKE ? OR members.middle_name LIKE ?", "%#{params[:search_member]}%",
        "%#{params[:search_member]}%", "%#{params[:search_member]}%")
      end

      @pagy_batch, @filtered_batches  = pagy(@batches, items: 10, page_param: :batch, link_extra: 'data-turbo-frame="pc_pagination1"')
      @group_remit = @process_coverage.group_remit

      @total_net_prem = @process_coverage.sum_batches_net_premium

    elsif ["GYRT","GYRTF","GYRTBR","GYRTFR","GBLISS","SIP","KOOPAMILYA"].include?(@plan.acronym)

      @insured_types = @process_coverage.group_remit.agreement.agreement_benefits.insured_types.symbolize_keys.values
      @insured_types2 = @process_coverage.group_remit.agreement.agreement_benefits
      puts "insured type id: #{@insured_types}"
      if params[:insured_type].present?
        # @batches_o = @group_remit.batches.joins(coop_member: [:member]).where(proposal_insured_id: params[:insured_type_id])
        # @batches_o = @process_coverage.group_remit.batches.joins(coop_member: [:member]).where(proposal_insured_id: params[:insured_type_id])
        @batches_o = @process_coverage.group_remit.batches.joins(coop_member: [:member]).where(agreement_benefit_id: params[:insured_type])
      else
        @batches_o = @process_coverage.group_remit.batches.includes(:coop_member, :member)
      end
      # @batches_o = @process_coverage.group_remit.batches.includes(:coop_member, :member)
      # raise 'errors'
      # if params[:search].present?
      if params[:search].present?
        @batches = case params[:search]
        when "regular_new" then @batches_o.where(age: 18..65, status: 0)
        when "regular_ren" then @batches_o.where(age: 18..65, status: 1..2)
        when "overage" then @batches_o.where(age: 66..)
        when "dependent" then @batches_o.joins(:batch_dependents).distinct
        when "reconsider" then @batches_o.where(status: :for_reconsideration)
          # when "health_decs" then @batches_o.joins(:batch_health_decs)
        when "health_decs" then @batches_o.joins(:batch_health_decs).where(batches: { valid_health_dec: false }).distinct
                     # when "health_decs" then @batches_o.joins(:batch_health_dec).where.not(batch_health_decs: { health_dec_question_id: nil })
        end
      else
        @batches = @batches_o
      end

      if params[:search_member].present?
        @batches = @batches_o.joins(coop_member: :member).where("members.last_name LIKE ? OR members.first_name LIKE ? OR members.middle_name LIKE ?", "%#{params[:search_member]}%",
        "%#{params[:search_member]}%", "%#{params[:search_member]}%")
      end

      @pagy_batch, @filtered_batches  = pagy(@batches, items: 10, page_param: :batch, link_extra: 'data-turbo-frame="pc_pagination"')

      @process_cov = ProcessCoverage.includes(group_remit: { batches: [:batch_remarks, coop_member: :member ] }).find(params[:id])

      @group_remit = @process_coverage.group_remit

      # @life_cov = ProcessCoverage.includes(group_remit: { agreement: { agreement_benefits: :product_benefits }}).find_by(id: @process_coverage.id).group_remit.agreement.agreement_benefits.joins(:product_benefits).where(agreement_benefits: {insured_type: 1}, product_benefits: {benefit_id: 1}).pluck('product_benefits.coverage_amount').first

      @batches_x = @process_coverage.group_remit.batches
      # @total_life_cov = ProductBenefit.joins(agreement_benefit: :batch).where('batches.id IN (?)', @batches_x.pluck(:id)).where('product_benefits.benefit_id = ?', 1).sum(:coverage_amount)
      # raise 'errors'
      # @total_life_cov = ProductBenefit.joins(agreement_benefit: :batches).where('batches.id IN (?)', @batches_x.pluck(:id)).where('product_benefits.benefit_id = ?', 1).sum(:coverage_amount)
      @total_life_cov = ProductBenefit.total_cov_amt(@batches_x)

      # principal premium
      @principal_net_prem = @process_coverage.get_principal_prem
      # @principal_net_prem = @process_coverage.group_remit.batches.where(insurance_status: "approved").sum(:premium) - (@process_coverage.group_remit.batches.where(insurance_status: "approved").sum(:coop_sf_amount) + @process_coverage.group_remit.batches.where(insurance_status: "approved").sum(:agent_sf_amount))

      # dependent premium
      @batch_dependents_net_prem = BatchDependent.gross_prem(@group_remit.id) - (BatchDependent.coop_sf_amt(@group_remit.id) + BatchDependent.agent_sf_amt(@group_remit.id))
      # @batch_dependents_net_prem = BatchDependent.joins(batch: { batch_group_remits: :group_remit}).where(group_remits: {id: @process_coverage.group_remit_id}).where(insurance_status: :approved).sum(:premium) - (BatchDependent.joins(batch: { batch_group_remits: :group_remit}).where(group_remits: {id: @process_coverage.group_remit_id}).where(insurance_status: :approved).sum(:coop_sf_amount) + BatchDependent.joins(batch: { batch_group_remits: :group_remit}).where(group_remits: {id: @process_coverage.group_remit_id}).where(insurance_status: :approved).sum(:agent_sf_amount))

      @total_net_prem = @principal_net_prem + @batch_dependents_net_prem

      # raise 'errors'
      # puts "#{@total_net_prem} ********************************"
    end

    @process_remarks = @process_coverage.process_remarks

    @pagy_rem, @filtered_remarks = pagy(@process_remarks, items: 3, page_param: :remark, link_extra: 'data-turbo-frame="pagination"')

    klass_name = @process_coverage.group_remit.batches.first.class.name
    @total_gross_prem = @process_coverage.sum_batches_gross_prem(klass_name)
  end

  # GET /process_coverages/new
  def new
    @process_coverage = ProcessCoverage.new
  end

  def set_premium_batch

    case params[:batch_type]
    when "LoanInsurance::Batch"
      @batch = LoanInsurance::Batch.find(params[:batch])
    else
      @batch = Batch.find(params[:batch])
    end
  end

  def adjust_lppi_cov
    @batch = LoanInsurance::Batch.find(params[:batch])
  end

  def transfer_to_md
    case params[:batch_type]
    when "LoanInsurance::Batch"
      @batch = LoanInsurance::Batch.find(params[:batch])
    else
      @batch = Batch.find(params[:batch])
    end

    respond_to do |format|
      @batch.batch_remarks.create(remark: "For M.D. Recommendation", status: :md_reco, user: current_user.userable)
      @batch.update(for_md: true, insurance_status: :md_recom)
      format.html { redirect_to @process_coverage, notice: "Batch sent to M.D. for review"  }
    end

  end

  def update_batch_prem
    # raise 'errors'
    @group_remit = @process_coverage.group_remit

    case @process_coverage.get_batch_class_name
    when "LoanInsurance::Batch"
      @batch = LoanInsurance::Batch.find_by(id: params[:process_coverage][:batch])
      rate = params[:process_coverage][:premium].to_d
      @batch.add_adjustment(rate)
      # @batch.update_prem_substandard(rate)
      # @batch.substandard = true
    else
      @batch = Batch.find_by(id: params[:process_coverage][:batch])
      @premium = params[:process_coverage][:premium].to_d
      @batch.set_premium_and_sf_for_reconsider(@group_remit, @premium)
    end


    @batch.insurance_status = :pending
    # @batch.batch_remarks.build(remark: "Adjusted Premium set. Premium: #{@batch.premium}", status: :prem_adjust, user_type: "Employee", user_id: current_user.userable.id)
    @batch.batch_remarks.build(remark: "Adjusted Premium and Coverage set.", status: :prem_adjust, user_type: "Employee", user_id: current_user.userable.id)

    respond_to do |format|
      # raise 'errors'
      if @batch.save!
        # @group_remit.set_total_premiums_and_fees
        if @process_coverage.get_plan_acronym == "LPPI"
          @group_remit.update(status: :with_substandard_members)
          format.html { redirect_to process_coverage_path(@process_coverage), notice: "Batch Premium Updated!"}
        else
          @group_remit.update(status: :with_pending_members)
          format.html { redirect_to process_coverage_path(@process_coverage, search: "reconsider"), notice: "Batch Premium Updated!"}
        end
      end
    end

  end

  def update_batch_cov
    @group_remit = @process_coverage.group_remit

    @batch = LoanInsurance::Batch.find_by(id: params[:process_coverage][:batch])
    loan_amount = params[:process_coverage][:loan_amount]
    # @batch.loan_amount = loan_amount
    @batch.adjusted_cov = loan_amount
    @batch.insurance_status = :pending
    @batch.batch_remarks.build(remark: "Adjusted Coverage set. Coverage: #{@batch.loan_amount}", status: :cov_adjust, user_type: "Employee", user_id: current_user.userable.id)

    respond_to do |format|
      if @batch.save!
        @group_remit.update(status: :with_substandard_members)
        format.html { redirect_to process_coverage_path(@process_coverage), notice: "Batch Coverage Updated!"}
      end
    end
  end

  def approve

    @max_amount = params[:max_amount].to_i
    @total_life_cov = params[:total_life_cov].to_i
    # @total_net_prem = params[:total_net_prem].to_i
    @total_gross_prem = params[:total_gross_prem].to_i
    # raise 'errors'

    @process_coverage = ProcessCoverage.find_by(id: params[:process_coverage_id])
    # compute group remit total premiums, fees and set status to :for_payment
    # @process_coverage.group_remit.set_total_premiums_and_fees
    klass_name = @process_coverage.group_remit.batches.first.class.name

    respond_to do |format|
      if current_user.rank == "analyst"

        if @max_amount >= @total_gross_prem
          if @process_coverage.count_batches("denied") > 0
            @process_coverage.update(status: :for_head_approval, process_date: Date.today, who_processed: current_user.userable)
            format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage for Head Approval!" }
          else
            @process_coverage.update(status: :approved, process_date: Date.today, evaluate_date: Date.today, who_approved: current_user.userable)
            format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage Approved!" }
          end
        else
          @process_coverage.update_attribute(:status, "for_head_approval")
          format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage for Head Approval!" }
        end

      elsif current_user.rank == "head"

        if @max_amount >= @total_gross_prem
          @process_coverage.update(status: :approved, evaluate_date: Date.today, who_approved: current_user.userable)
          format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage Approved!" }
        else
          @process_coverage.update_attribute(:status, "for_vp_approval")
          format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage for VP approval!" }
        end

      elsif current_user.rank == "senior_officer"
        @process_coverage.update(status: :approved, evaluate_date: Date.today, who_approved: current_user.userable)
        format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage Approved!" }
      end
    end

    @process_coverage.group_remit.set_total_premiums_and_fees
  end

  def refund
    if params[:type].present?
      request = VoucherRequestService.new(@process_coverage, @process_coverage.group_remit.denied_premiums, :refund, current_user, :journal_voucher, nil, "denied")
    else
      request = VoucherRequestService.new(@process_coverage, @process_coverage.group_remit.refund_amount, :refund, current_user)
    end

    if request.create_request
      redirect_to process_coverage_path(@process_coverage), notice: "Refund request sent!"
    else
      redirect_to process_coverage_path(@process_coverage), alert: "Error sending refund request!"
    end
  end

  def deny
    @process_coverage = ProcessCoverage.find_by(id: params[:process_coverage_id])

    respond_to do |format|
      if @process_coverage.update_attribute(:status, "denied")
        format.html { redirect_to process_coverage_path(@process_coverage), alert: "Process Coverage Denied!" }
      end
    end
  end

  def reassess
    @process_coverage = ProcessCoverage.find_by(id: params[:process_coverage_id])
    @group_remit = @process_coverage.group_remit

    respond_to do |format|
      if @process_coverage.update_attribute(:status, "reassess")
        @group_remit.update_attribute(:status, "under_review")
        format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage For Reassessment!" }
      end
    end
  end

  def reprocess
    @process_coverage = ProcessCoverage.find_by(id: params[:process_coverage_id])

    respond_to do |format|
      if current_user.analyst?
        # if @process_coverage.update_attribute(:status, "reprocess")
        if @process_coverage.update_attribute(:status, "reprocess_request")
          format.html { redirect_to process_coverage_path(@process_coverage), warning: "Reprocess request submitted!" }
        end
      elsif current_user.head? || current_user.senior_officer?
        # if @process_coverage.update_attribute(:status, "for_review")
        if @process_coverage.update_attribute(:status, "reprocess_approved")
          @process_coverage.update(reprocess: true)
          @process_coverage.group_remit.update(status: :under_review)
          format.html { redirect_to process_coverage_path(@process_coverage), notice: "Reprocess Coverage approved!" }
        end
      else
        format.html { redirect_to process_coverage_path(@process_coverage), alert: "error" }
      end
    end
  end

  def approve_batch
    # raise 'errors'
    @batch = case params[:batch_type]
    when "LoanInsurance::Batch"
      LoanInsurance::Batch.find(params[:batch])
    else
      Batch.find(params[:batch])
    end

    respond_to do |format|
      if (@batch.class.name == "Batch") && (@batch.batch_dependents.for_review.count > 0 || @batch.batch_dependents.pending.count > 0)
        format.html { redirect_to process_coverage_path(@process_coverage), alert: "Please check pending and/or for review dependent(s) for that coverage." }
      else
        if @batch.update_attribute(:insurance_status, 0)
          # @process_coverage.increment!(:approved_count)
          # @process_coverage.update(approved_count: @process_coverage.count_batches_approved(params[:batch_type]), denied_count: @process_coverage.count_batches_denied(params[:batch_type]))
          @process_coverage.update(approved_count: @process_coverage.count_batches("approved"), denied_count: @process_coverage.count_batches("denied"))
          format.html { redirect_to process_coverage_path(@process_coverage), notice: "Batch Approved!" }
        end
      end

    end

  end

  def approve_dependent
    @dependent = BatchDependent.find(params[:dependent])
    @batch = @dependent.batch
    @group_remit = @batch.group_remits.find(params[:group_remit_id])

    respond_to do |format|
      if @dependent.update_attribute(:insurance_status, 0)
        format.html { redirect_to show_all_group_remit_batch_dependents_path(@group_remit, @batch, process_coverage_id: params[:id]), notice: "Dependent Approved!" }
        format.turbo_stream { render turbo_stream: turbo_stream.update("approved_message", partial: "layouts/notification") }
      end
    end
  end

  # def pending_batch
  #   # raise 'errors'
  #   @batch = Batch.find(params[:batch])
  def pending_batch
    # raise 'errors'
    @batch = case params[:batch_type]
    when "LoanInsurance::Batch"
      LoanInsurance::Batch.find(params[:batch])
    else
      Batch.find(params[:batch])
             end

    #   respond_to do |format|
    #     if @batch.update_attribute(:insurance_status, 2)
    #       format.html { redirect_to process_coverage_path(@process_coverage), notice: "Pending batch updated!" }
    #     end
    #   end
  end

  def deny_batch
    @batch = case params[:batch_type]
    when "LoanInsurance::Batch"
      LoanInsurance::Batch.find(params[:batch])
    else
      Batch.find(params[:batch])
             end

    if (@batch.class.name == "Batch") && (@batch.batch_dependents.for_review.count > 0 || @batch.batch_dependents.pending.count > 0)
      redirect_to process_coverage_path(@process_coverage), alert: "Please check pending and/or for review dependent(s) for that coverage."
    else
      respond_to do |format|
        if @batch.update_attribute(:insurance_status, 1)
          # @process_coverage.update(approved_count: @process_coverage.count_batches_approved(params[:batch_type]), denied_count: @process_coverage.count_batches_denied(params[:batch_type]))
          @process_coverage.update(approved_count: @process_coverage.count_batches("approved"), denied_count: @process_coverage.("denied"))
          format.html { redirect_to process_coverage_path(@process_coverage), alert: "Batch Denied!" }
        end
      end
    end
  end

  def reconsider_batch

    @batch = case params[:batch_type]
    when "LoanInsurance::Batch"
      LoanInsurance::Batch.find(params[:batch])
    else
      Batch.find(params[:batch])
             end

    respond_to do |format|
      if @batch.update_attribute(:insurance_status, 3)
        format.html { redirect_to process_coverage_path(@process_coverage), notice: "Batch updated to For Review!" }
      end
    end
  end

  def modal_remarks

    @batch = case params[:batch_type]
    when "LoanInsurance::Batch"
      LoanInsurance::Batch.find(params[:batch])
    else
      Batch.find(params[:batch])
             end

    @batch_remarks = @batch.batch_remarks# .where(remarkable_type: @batch.class.name)
    @pagy_br, @filtered_br = pagy(@batch_remarks, items: 3, page_param: :b_remarks)
    @process_coverage = ProcessCoverage.find(params[:id])
  end

  # GET /process_coverages/1/edit
  def edit
  end

  # POST /process_coverages
  def create
    @process_coverage = ProcessCoverage.new(process_coverage_params)

    if @process_coverage.save
      redirect_to @process_coverage, notice: "Process coverage was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def psheet
    @batches_x = @process_coverage.group_remit.batches
    @total_life_cov = case @process_coverage.get_plan_acronym
    when "LPPI"
      @process_coverage.group_remit.total_loan_amount
    else
      ProductBenefit.joins(agreement_benefit: :batches).where("batches.id IN (?)", @batches_x.pluck(:id)).where(batches: { insurance_status: :approved }).where("product_benefits.benefit_id = ?", 1).sum(:coverage_amount)
    end
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "PSHEET ##{@process_coverage.id}",
        template: "process_coverages/psheet",
        formats: [:html],
        page_size: "A4",
        layouts: "pdf",
        viewport_size: '1280x1024'
      end
    end

  end

  # PATCH/PUT /process_coverages/1
  def update
    if @process_coverage.update(process_coverage_params)
      redirect_to @process_coverage, notice: "Process coverage was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /process_coverages/1
  def destroy
    @process_coverage.destroy
    redirect_to process_coverages_url, notice: "Process coverage was successfully destroyed."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_process_coverage
    @process_coverage = ProcessCoverage.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def process_coverage_params
    params.require(:process_coverage).permit(:group_remit_id, :agent_id, :effectivity, :expiry, :status, :approved_count, :approved_total_coverage, :approved_total_prem, :denied_count,
  :denied_total_coverage, :denied_total_prem)
  end

  # def check_emp_department
  #   unless (current_user.userable_type == "Employee" && current_user.userable.department_id == 17) || current_user.senior_officer? # check if underwriting
  #     render file: "#{Rails.root}/public/404.html", status: :not_found
  #   end
  # end
end
