class ProcessCoveragesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_emp_department
  before_action :set_process_coverage, only: %i[ show edit update destroy approve_batch deny_batch pending_batch reconsider_batch pdf set_premium_batch update_batch_prem ]

  # GET /process_coverages
  def index
    # raise 'errors'
    if current_user.rank == "senior_officer"
      @process_coverages_x = ProcessCoverage.all
      @process_coverages_x = ProcessCoverage.all
      @for_process_coverages = ProcessCoverage.where(status: :for_process)
      @approved_process_coverages = ProcessCoverage.where(status: :approved)
      # @pending_process_coverages = ProcessCoverage.where(status: :pending)
      @reprocess_coverages = ProcessCoverage.where(status: :reprocess)
      @reassess_coverages = ProcessCoverage.where(status: :reassess)
      @denied_process_coverages = ProcessCoverage.where(status: :denied)

      if params[:search].present?
        @process_coverages = @process_coverages_x.joins(group_remit: {agreement: :cooperative}).where("group_remits.name LIKE ? OR group_remits.description LIKE ? OR agreements.moa_no LIKE ? OR cooperatives.name LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
      else
        @process_coverages = @process_coverages_x
      end

      if params[:emp_id].present?
        # raise 'errors'
        date_from = params[:date_from]
        date_to = params[:date_to]
        @process_coverages = @process_coverages_x.where(processor_id: params[:emp_id], status: :for_process, created_at: date_from..date_to)
      end
      
    elsif current_user.rank == "head" 
      # @process_coverages_x = ProcessCoverage.joins(group_remit: { agreement: :emp_agreements }).where( emp_agreements: { approver_id: current_user.userable_id, active: true })
      # @process_coverages_x = ProcessCoverage.joins(group_remit: { agreement: { emp_agreements: {employee: :emp_approver} } }).where( emp_approver: { approver_id: current_user.userable_id }, emp_agreements: { active: true })
      # @process_coverages_x = ProcessCoverage.joins(group_remit: { agreement: { emp_agreements: {employee: :emp_approver} } }).where(approver: current_user.userable_id)
      @process_coverages_x = ProcessCoverage.joins(group_remit: :agreement).where(approver: current_user.userable_id)
      # @process_coverages_x = ProcessCoverage.all
      @for_process_coverages = @process_coverages_x.where(status: :for_process)
      @approved_process_coverages = @process_coverages_x.where(status: :approved)
      # @pending_process_coverages = ProcessCoverage.where(status: :pending)
      @reprocess_coverages = @process_coverages_x.where(status: :reprocess)
      @reassess_coverages = ProcessCoverage.where(status: :reassess)
      @denied_process_coverages = @process_coverages_x.where(status: :denied)

      if params[:search].present?
        @process_coverages = @process_coverages_x.joins(group_remit: {agreement: :cooperative}).where("group_remits.name LIKE ? OR group_remits.description LIKE ? OR agreements.moa_no LIKE ? OR cooperatives.name LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
      else
        @process_coverages = @process_coverages_x
      end

      if params[:emp_id].present?
        # raise 'errors'
        date_from = params[:date_from]
        date_to = params[:date_to]
        @process_coverages = @process_coverages_x.where(processor_id: params[:emp_id], status: params[:process_type], created_at: date_from..date_to)
      end

    elsif current_user.analyst?
      # @process_coverages_x = ProcessCoverage.joins(group_remit: { agreement: :emp_agreements }).where( emp_agreements: { employee_id: current_user.userable_id, active: true })
      @process_coverages_x = ProcessCoverage.joins(group_remit: {agreement: :plan}).where(processor: current_user.userable_id)
      
      if params[:search].present?
        @process_coverages = @process_coverages_x.joins("INNER JOIN cooperatives ON cooperatives.id = agreements.cooperative_id").where("group_remits.name LIKE ? OR group_remits.description LIKE ? OR agreements.moa_no LIKE ? OR cooperatives.name LIKE ? OR agreements.description LIKE ? OR plans.name LIKE ? OR plans.acronym LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
      else
        @process_coverages = @process_coverages_x
      end

      if params[:emp_id].present?
        # raise 'errors'
        date_from = Date.strptime(params[:date_from], '%m-%d-%Y')
        date_to = Date.strptime(params[:date_to], '%m-%d-%Y')
        @process_coverages = @process_coverages_x.where(processor_id: params[:emp_id], status: params[:process_type], created_at: date_from..date_to)
      end
      
    else
      @process_coverages_x = ProcessCoverage.all
    end

    @analysts_x = Employee::ANALYSTS
    if current_user.senior_officer?
      @analysts = @analysts_x.joins(:emp_approver)
    elsif current_user.head?
      @analysts = @analysts_x.joins(:emp_approver).where(emp_approver: { approver: current_user.userable_id })
    end

    # if params[:search].present?
    #   @process_coverages = @process_coverages_x.joins(group_remit: {agreement: :cooperative}).where("group_remits.name LIKE ? OR group_remits.description LIKE ? OR agreements.moa_no LIKE ? OR cooperatives.name LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    # else
    #   @process_coverages = @process_coverages_x
    # end
    
  end

  def preview
    pdf = Prawn::Document.new
    pdf.text "This is a preview"
    pdf.text "It only shows up in the preview route"
    pdf.start_new_page
    pdf.text "this is new page"
    100.times do |i|
      pdf.text "this is line #{i}"
    end
    send_data(pdf.render,
      filename: "hello.pdf",
      type: "application/pdf",
      disposition: "inline")

  end

  def download
    pdf = Prawn::Document.new
    pdf.text "Hello World"
    send_data(pdf.render,
      filename: 'hello.pdf',
      type: 'application/pdf')
    
  end

  def pdf
    @batches_x = @process_coverage.group_remit.batches
    @total_life_cov = ProductBenefit.joins(agreement_benefit: :batches).where('batches.id IN (?)', @batches_x.pluck(:id)).where('product_benefits.benefit_id = ?', 1).sum(:coverage_amount)

    pdf = PsheetPdf.new(@process_coverage, @total_life_cov, view_context)
    send_data(pdf.render,
      filename: "#{@process_coverage.group_remit.name}.pdf",
      type: 'application/pdf',
      disposition: "inline")
  end
  

  def cov_list
    # raise 'errors'
    @current_date = params[:current_date]&.to_date
    @process_coverages = case params[:cov_type]
      when "For Process" 
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
        # ProcessCoverage.where(status: :for_process, created_at: start_date..end_date)
        if current_user.head?
          ProcessCoverage.joins(group_remit: { agreement: { emp_agreements: {employee: :emp_approver} } }).where( emp_approver: { approver_id: current_user.userable_id }, emp_agreements: { active: true}).where(status: :for_process, created_at: start_date..end_date)
        elsif current_user.senior_officer?
          ProcessCoverage.where(status: :for_process, created_at: start_date..end_date)
        end
        
      when "Approved" 
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
        # ProcessCoverage.where(status: :approved, created_at: start_date..end_date)
        if current_user.head?
          ProcessCoverage.joins(group_remit: { agreement: { emp_agreements: {employee: :emp_approver} } }).where( emp_approver: { approver_id: current_user.userable_id }, emp_agreements: { active: true}).where(status: :approved, created_at: start_date..end_date)
        elsif current_user.senior_officer?
          ProcessCoverage.where(status: :approved, created_at: start_date..end_date)
        end

      when "Reconsider" 
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
        # ProcessCoverage.where(status: :for_reconsider, created_at: start_date..end_date)
        if current_user.head?
          ProcessCoverage.joins(group_remit: { agreement: { emp_agreements: {employee: :emp_approver} } }).where( emp_approver: { approver_id: current_user.userable_id }, emp_agreements: { active: true}).where(status: :reprocess, created_at: start_date..end_date)
        elsif current_user.senior_officer?
          ProcessCoverage.where(status: :reprocess, created_at: start_date..end_date)
        end

      when "Reassess" 
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
        # ProcessCoverage.where(status: :for_reconsider, created_at: start_date..end_date)
        if current_user.head?
          ProcessCoverage.joins(group_remit: { agreement: { emp_agreements: {employee: :emp_approver} } }).where( emp_approver: { approver_id: current_user.userable_id }, emp_agreements: { active: true}).where(status: :reassess, created_at: start_date..end_date)
        elsif current_user.senior_officer?
          ProcessCoverage.where(status: :reassess, created_at: start_date..end_date)
        end

      when "Denied" 
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
        if current_user.head?
          ProcessCoverage.joins(group_remit: { agreement: { emp_agreements: {employee: :emp_approver} } }).where( emp_approver: { approver_id: current_user.userable_id }, emp_agreements: { active: true}).where(status: :denied, created_at: start_date..end_date)
        elsif current_user.senior_officer?
          ProcessCoverage.where(status: :denied, created_at: start_date..end_date)
        end
      when "head approval" then ProcessCoverage.where(status: :for_head_approval)
      when "vp approval" then ProcessCoverage.where(status: :for_head_approval)
    end

    @title = params[:title]
    
  end

  def update_batch_selected
    # raise 'errors'
    @pro_cov = ProcessCoverage.find_by(id: params[:p_id])
    ids = params[:b_ids]
    
    if params[:approve]

      Batch.where(id: ids).update_all(insurance_status: :approved)
      @pro_cov.increment!(:approved_count, ids.length)

      redirect_to process_coverage_path(@pro_cov), notice: "Selected Coverages Approved!"
      
    elsif params[:deny]
  
      Batch.where(id: ids).update_all(insurance_status: :denied)
      @pro_cov.increment!(:denied_count, ids.length)

      redirect_to process_coverage_path(@pro_cov), alert: "Selected Coverages Denied!"
    end
    
    # redirect_to process_coverage_path(@process_coverage), notice: "Selected Coverages Approved!"
  end
  
  # GET /process_coverages/1
  def show
    @plan = @process_coverage.get_plan
    if @plan.acronym == "LPPI"
      @batches_o = @process_coverage.group_remit.batches
      if params[:search].present?
        @batches = case params[:search]
        when "regular_new" then @batches_o.where(age: 18..65, status: 0)
        when "regular_ren" then @batches_o.where(age: 18..65, status: 1..2)
        when "overage" then @batches_o.where(age: 66..)
        when "reconsider" then @batches_o.where(status: :for_reconsideration)
          # when "health_decs" then @batches_o.joins(:batch_health_decs)
        when "health_decs" then @batches_o.joins(:batch_health_decs).where(loan_insurance_batches: { valid_health_dec: false }).distinct
          # when "health_decs" then @batches_o.joins(:batch_health_dec).where.not(batch_health_decs: { health_dec_question_id: nil })
        end
      else
        @batches = @batches_o
      end

      if params[:search_member].present?
        @batches = @batches_o.joins(coop_member: :member).where("members.last_name LIKE ? OR members.first_name LIKE ? OR members.middle_name LIKE ?", "%#{params[:search_member]}%", "%#{params[:search_member]}%", "%#{params[:search_member]}%")
      end

      @pagy_batch, @filtered_batches  = pagy(@batches, items: 10, page_param: :batch)
      @group_remit = @process_coverage.group_remit

      @total_net_prem = @process_coverage.sum_batches_net_premium

    elsif ["GYRT","GYRTF","GYRTBR","GYRTFR"].include?(@plan.acronym)

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
        when "reconsider" then @batches_o.where(status: :for_reconsideration)
          # when "health_decs" then @batches_o.joins(:batch_health_decs)
        when "health_decs" then @batches_o.joins(:batch_health_decs).where(batches: { valid_health_dec: false }).distinct
          # when "health_decs" then @batches_o.joins(:batch_health_dec).where.not(batch_health_decs: { health_dec_question_id: nil })
        end
      else
        @batches = @batches_o
      end
      
      if params[:search_member].present?
        @batches = @batches_o.joins(coop_member: :member).where("members.last_name LIKE ? OR members.first_name LIKE ? OR members.middle_name LIKE ?", "%#{params[:search_member]}%", "%#{params[:search_member]}%", "%#{params[:search_member]}%")
      end
  
      @pagy_batch, @filtered_batches  = pagy(@batches, items: 10, page_param: :batch)
  
      @process_cov = ProcessCoverage.includes(group_remit: { batches: [:batch_remarks, coop_member: :member ] }).find(params[:id])
  
     
  
      # @life_cov = ProcessCoverage.includes(group_remit: { moa: { proposal:{ proposal_insureds: :proposal_insured_benefits }}}).find_by(id: @process_coverage.id).group_remit.moa.proposal.proposal_insureds.joins(:proposal_insured_benefits).where(proposal_insureds: {insured_type: 1}, proposal_insured_benefits: {benefit: 1}).pluck('proposal_insured_benefits.cov_amount').first
  
      # @life_cov = ProcessCoverage.includes(group_remit: { agreement: { agreement_benefits: :product_benefits }}).find_by(id: @process_coverage.id).group_remit.agreement.agreement_benefits.joins(:product_benefits).where(agreement_benefits: {insured_type: 1}, product_benefits: {benefit_id: 1}).pluck('product_benefits.coverage_amount').first
  
      @life_cov = ProcessCoverage.includes(group_remit: { agreement: { agreement_benefits: :product_benefits }}).find_by(id: @process_coverage.id).group_remit.agreement.agreement_benefits.joins(:product_benefits).where(agreement_benefits: {insured_type: 1}, product_benefits: {benefit_id: 1}).pluck('product_benefits.coverage_amount').first
  
      @batches_x = @process_coverage.group_remit.batches
      # @total_life_cov = ProductBenefit.joins(agreement_benefit: :batch).where('batches.id IN (?)', @batches_x.pluck(:id)).where('product_benefits.benefit_id = ?', 1).sum(:coverage_amount)
      # raise 'errors'
      @total_life_cov = ProductBenefit.joins(agreement_benefit: :batches).where('batches.id IN (?)', @batches_x.pluck(:id)).where('product_benefits.benefit_id = ?', 1).sum(:coverage_amount)
  
      #principal premium
      @principal_net_prem = @process_coverage.group_remit.batches.where(insurance_status: "approved").sum(:premium) - (@process_coverage.group_remit.batches.where(insurance_status: "approved").sum(:coop_sf_amount) + @process_coverage.group_remit.batches.where(insurance_status: "approved").sum(:agent_sf_amount))
      
      #dependent premium
      @batch_dependents_net_prem = BatchDependent.joins(batch: { batch_group_remits: :group_remit}).where(group_remits: {id: @process_coverage.group_remit_id}).where(insurance_status: :approved).sum(:premium) - (BatchDependent.joins(batch: { batch_group_remits: :group_remit}).where(group_remits: {id: @process_coverage.group_remit_id}).where(insurance_status: :approved).sum(:coop_sf_amount) + BatchDependent.joins(batch: { batch_group_remits: :group_remit}).where(group_remits: {id: @process_coverage.group_remit_id}).where(insurance_status: :approved).sum(:agent_sf_amount))
      
      @total_net_prem = @principal_net_prem + @batch_dependents_net_prem
  
      @group_remit = @process_coverage.group_remit
      # raise 'errors'
      puts "#{@total_net_prem} ********************************"
    end

    @process_remarks = @process_coverage.process_remarks
  
    @pagy_rem, @filtered_remarks = pagy(@process_remarks, items: 3, page_param: :remark)

    klass_name = @process_coverage.group_remit.batches.first.class.name
    @total_gross_prem = @process_coverage.sum_batches_gross_prem(klass_name)
  end

  # GET /process_coverages/new
  def new
    @process_coverage = ProcessCoverage.new
  end

  def set_premium_batch
    @batch = Batch.find(params[:batch])
  end

  def update_batch_prem
    # raise 'errors'
    @batch = Batch.find_by(id: params[:process_coverage][:batch])
    @premium = params[:process_coverage][:premium].to_d
    @group_remit = @process_coverage.group_remit
    
    @batch.set_premium_and_sf_for_reconsider(@group_remit, @premium)
    @batch.insurance_status = :pending
    @batch.batch_remarks.build(remark: "Adjusted Premium set. Premium: #{@batch.premium}", status: :pending, user_type: 'Employee', user_id: current_user.userable.id)

    respond_to do |format|
      if @batch.save!
        # @group_remit.set_total_premiums_and_fees
        @group_remit.update(status: :with_pending_members) 
        format.html { redirect_to process_coverage_path(@process_coverage, search: 'reconsider'), notice: "Batch Premium Updated!"}
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
    @process_coverage.group_remit.set_total_premiums_and_fees
    klass_name = @process_coverage.group_remit.batches.first.class.name

    respond_to do |format|
      if current_user.rank == "analyst"
        if @max_amount >= @total_gross_prem
                    
          if @process_coverage.count_batches_denied(klass_name) > 0
          # if @process_coverage.group_remit.batches.where(batches: { insurance_status: :denied }).count > 0
            @process_coverage.update_attribute(:status, "for_head_approval")
            format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage for Head Approval!" }
          else
            @process_coverage.update_attribute(:status, "approved")
            # @process_coverage.group_remit.set_total_premiums_and_fees
            format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage Approved!" }
          end
        else
          @process_coverage.update_attribute(:status, "for_head_approval")
          format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage for Head Approval!" }
        end
      elsif current_user.rank == "head"
        if @max_amount >= @total_gross_prem
          @process_coverage.update_attribute(:status, "approved")
          # @process_coverage.group_remit.set_total_premiums_and_fees
          format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage Approved!" }
        else
          @process_coverage.update_attribute(:status, "for_vp_approval")
          format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage for VP approval!" }
        end
      elsif current_user.rank == "senior_officer"
        @process_coverage.update_attribute(:status, "approved")
        # @process_coverage.group_remit.set_total_premiums_and_fees
        format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage Approved!" }
      end
    end
    # if @process_coverage.update_attribute(:status, "approved")
    #   @process_coverage.group_remit.set_total_premiums_and_fees
    #   format.html { redirect_to process_coverage_path(@process_coverage), notice: "Process Coverage Approved!" }
    # end
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
    respond_to do |format|
      if @process_coverage.update_attribute(:status, "reassess")
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
      if @batch.batch_dependents.for_review.count > 0 || @batch.batch_dependents.pending.count > 0
        format.html { redirect_to process_coverage_path(@process_coverage), alert: "Please check pending and/or for review dependent(s) for that coverage." }
      else
        if @batch.update_attribute(:insurance_status, 0)
          @process_coverage.increment!(:approved_count)
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
        format.turbo_stream { render turbo_stream: turbo_stream.update('approved_message', partial: 'layouts/notification') }
      end
    end
  end

  def pending_batch
    # raise 'errors'
    @batch = case params[:batch_type]
    when "LoanInsurance::Batch"
      LoanInsurance::Batch.find(params[:batch])
    else
      Batch.find(params[:batch])
    end 

    respond_to do |format|
      if @batch.update_attribute(:insurance_status, 2)
        format.html { redirect_to process_coverage_path(@process_coverage), notice: "Pending batch updated!" }
      end
    end
  end

  def deny_batch
    @batch = case params[:batch_type]
    when "LoanInsurance::Batch"
      LoanInsurance::Batch.find(params[:batch])
    else
      Batch.find(params[:batch])
    end 

    if @batch.batch_dependents.for_review.count > 0 || @batch.batch_dependents.pending.count > 0
      redirect_to process_coverage_path(@process_coverage), alert: "Please check pending and/or for review dependent(s) for that coverage."
    else
      respond_to do |format|
        if @batch.update_attribute(:insurance_status, 1)
          @process_coverage.increment!(:denied_count)
          format.html { redirect_to process_coverage_path(@process_coverage), alert: "Batch Denied!" }
        end
      end
    end
  end

  def reconsider_batch
    @batch = Batch.find(params[:batch])

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
    
    @batch_remarks = @batch.batch_remarks.where(batch_type: @batch.class.name)
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
    params.require(:process_coverage).permit(:group_remit_id, :agent_id, :effectivity, :expiry, :status, :approved_count, :approved_total_coverage, :approved_total_prem, :denied_count, :denied_total_coverage, :denied_total_prem)
    end

    def check_emp_department
      unless (current_user.userable_type == 'Employee' && current_user.userable.department_id == 17) || current_user.senior_officer? #check if underwriting
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
