class DashboardsController < ApplicationController
  include ProcessClaimHelper

    def admin
      @users = User.all
      @schedules = DemoSchedule.all
      render :index
    end

    def actuarial
        @claim_reinsurance = Claims::ClaimReinsurance.where(status: 0)
        render :index
    end

    def claims
        @user_levels = current_user.user_levels.where(active: 1) if current_user
        @for_evaluation = Claims::ProcessClaim.where(claim_route: get_route_evaluators) if current_user.userable_type == "Employee" unless @claims_user_authority_level.nil?
        # unless @claims_user_authority_level == "Claims Evaluator" ||  @claims_user_authority_level == "COSO (Approver)" || @claims_user_authority_level == "President (Approver)"
        #   @for_evaluation = Claims::ProcessClaim.where(claim_route: 3)
        # end
        @coop_messages = Claims::ClaimRemark.where(coop: 1)
        @process_claims = Claims::ProcessClaim.all
        @claim_reinsurances = Claims::ClaimReinsurance.all
        @claims_fund = Claims::CfAccount.all
        @cf_availments = Claims::CfAvailment.all
        @cf_replenishes = Claims::CfReplenish.all
        render :index
    end

    def coop
        @cooperative = current_user.userable.cooperative
        @notifications = @cooperative.notifications
        @coop_messages = Claims::ClaimRemark.where(coop: 1)
        @process_claims = Claims::ProcessClaim.where(cooperative: @cooperative)

        @coop_group_remits = @cooperative.group_remits
        @pending_lppi = LoanInsurance::Batch.get_pending_lppi(@coop_group_remits)
        @pending_gyrt = Batch.get_pending_gyrt(@coop_group_remits)

        @group_remits_pending = @cooperative.group_remits.where(status: :pending)


        #for graphs
        @age_bracket = [
          ["18-65", @cooperative.get_age_demo("regular")],
          ["66-70", @cooperative.get_age_demo("66")],
          ["71-75", @cooperative.get_age_demo("71")],
          ["76-80", @cooperative.get_age_demo("76")],
          ["81-85", @cooperative.get_age_demo("81")]
        ]

        @gender_counts = [
          ["Male", @cooperative.coop_members.includes(:member).where(member: { gender: ['Male', "MALE", "M"] }).count],
          ["Female", @cooperative.coop_members.includes(:member).where(member: { gender: ['Female', "FEMALE", "F"] }).count],
          ["Other", @cooperative.coop_members.includes(:member).where(member: { gender: ['-', nil] }).count]
        ]
        render :index
    end

    def treasury
      @encoded_ors = Treasury::CashierEntry.where(employee: current_user.userable)
      @posted_ors = Treasury::CashierEntry.posted.where(employee: current_user.userable)
      @cancelled_ors = Treasury::CashierEntry.cancelled.where(employee: current_user.userable)
      @for_approval_ors = Treasury::CashierEntry.for_approval.where(employee: current_user.userable)
      @pending_ors = Treasury::CashierEntry.pending.where(employee: current_user.userable)
      @need_approval = Treasury::CashierEntry.for_approval
      @payments = Payment.for_review
      @for_business_checks = Accounting::Check.approved.posted.where(claimable: false)
      @for_debit_advice = Accounting::DebitAdvice.approved.pending_payout

      render :index
    end

  # def actuarial
  #     @claim_reinsurance = Claims::ClaimReinsurance.where(status: 0)
  #     render :index
  # end

  # def claims
  #     @user_levels = current_user.user_levels.where(active: 1) if current_user
  #     @for_evaluation = Claims::ProcessClaim.where(claim_route: get_route_evaluators) if current_user.userable_type == "Employee" unless @claims_user_authority_level.nil?
  #     # unless @claims_user_authority_level == "Claims Evaluator" ||  @claims_user_authority_level == "COSO (Approver)" || @claims_user_authority_level == "President (Approver)"
  #     #   @for_evaluation = Claims::ProcessClaim.where(claim_route: 3)
  #     # end
  #     @coop_messages = Claims::ClaimRemark.where(coop: 1)
  #     @process_claims = Claims::ProcessClaim.all
  #     @claim_reinsurances = Claims::ClaimReinsurance.all
  #     @claims_fund = Claims::CfAccount.all
  #     @cf_availments = Claims::CfAvailment.all
  #     @cf_replenishes = Claims::CfReplenish.all
  #     render :index
  # end

  # def coop
  #     @cooperative = current_user.userable.cooperative
  #     @notifications = @cooperative.notifications
  #     @coop_messages = Claims::ClaimRemark.where(coop: 1)
  #     @process_claims = Claims::ProcessClaim.where(cooperative: @cooperative)

  #     @coop_group_remits = @cooperative.group_remits
  #     @pending_lppi = LoanInsurance::Batch.get_pending_lppi(@coop_group_remits)
  #     @pending_gyrt = Batch.get_pending_gyrt(@coop_group_remits)

  #     @group_remits_pending = @cooperative.group_remits.where(status: :pending)


  #     #for graphs
  #     @age_bracket = [
  #       ["18-65", @cooperative.get_age_demo("regular")],
  #       ["66-70", @cooperative.get_age_demo("66")],
  #       ["71-75", @cooperative.get_age_demo("71")],
  #       ["76-80", @cooperative.get_age_demo("76")],
  #       ["81-85", @cooperative.get_age_demo("81")]
  #     ]

  #     @gender_counts = [
  #       ["Male", @cooperative.coop_members.includes(:member).where(member: { gender: ['Male', "MALE", "M"] }).count],
  #       ["Female", @cooperative.coop_members.includes(:member).where(member: { gender: ['Female', "FEMALE", "F"] }).count],
  #       ["Other", @cooperative.coop_members.includes(:member).where(member: { gender: ['-', nil] }).count]
  #     ]
  #     render :index
  # end

  # def treasury
  #   @encoded_ors = Treasury::CashierEntry.where(employee: current_user.userable)
  #   @posted_ors = Treasury::CashierEntry.posted.where(employee: current_user.userable)
  #   @cancelled_ors = Treasury::CashierEntry.cancelled.where(employee: current_user.userable)
  #   @for_approval_ors = Treasury::CashierEntry.for_approval.where(employee: current_user.userable)
  #   @pending_ors = Treasury::CashierEntry.pending.where(employee: current_user.userable)
  #   @need_approval = Treasury::CashierEntry.for_approval
  #   @payments = Payment.for_review
  #   @for_business_checks = Accounting::Check.approved.posted.where(claimable: false)
  #   @for_debit_advice = Accounting::DebitAdvice.approved.pending_payout

  #   render :index
  # end

  def mis
    @encoded = GroupRemit.where(mis_entry: true, mis_user: current_user.id)
    @not_encoded = Treasury::CashierEntry.posted.includes(:agreement).where.not(or_no: GroupRemit.pluck(:official_receipt))
    @transmitted = TransmittalOr.joins(:transmittal).where(transmittal: { user: current_user })
    @with_ors = GroupRemit.where.not(id: TransmittalOr.with_ors_already).where(mis_entry: true, mis_user: current_user.id)
    @lppi_encoded = LoanInsurance::Batch.get_lppi_batches_count(current_user.id)
    @gyrt_encoded = Batch.get_gyrt_encoded(current_user.id)

    render :index
  end

  def accounting
    date_range = params[:date_from]&.to_date&.beginning_of_day..params[:date_to]&.to_date&.end_of_day
    @check_vouchers = Accounting::Check.where(employee: current_user.userable, date_voucher: date_range)
    @debit_advices = Accounting::DebitAdvice.where(employee: current_user.userable, date_voucher: date_range)
    @journal_vouchers = Accounting::Journal.where(employee: current_user.userable, date_voucher: date_range)

    request = Accounting::VoucherRequest.pending
    @check_req = request.check_voucher
    @da_req = request.debit_advice
    @journal_req = request.journal_voucher

    render :index
  end

  def coso
    @user_levels = current_user.user_levels.where(active: 1) if current_user

    #UNDERWRITING
    @process_coverages = ProcessCoverage.includes(:group_remit).where.not(group_remit: { gross_premium: nil })
    @for_approval_pcs = ProcessCoverage.where(status: :for_vp_approval)
    @approved_pcs = ProcessCoverage.where(status: :approved)
    @denied_pcs = ProcessCoverage.where(status: :denied)
    @pending_pcs = ProcessCoverage.where(status: [:pending, :for_head_approval, :for_vp_approval])

    #CLAIMS
    @for_evaluation = Claims::ProcessClaim.where(claim_route: get_route_evaluators) if current_user.userable_type == "Employee" unless @claims_user_authority_level.nil?
    
    @coop_messages = Claims::ClaimRemark.where(coop: 1)
    @process_claims = Claims::ProcessClaim.all
    @claim_reinsurances = Claims::ClaimReinsurance.all
    @claims_fund = Claims::CfAccount.all
    @cf_availments = Claims::CfAvailment.all
    @cf_replenishes = Claims::CfReplenish.all

    @cooperatives = Cooperative.all

    @agreements = Agreement.all
    @lppi_agreements = @agreements.includes(:plan).where(plan: { acronym: "LPPI" })
    @gyrt_agreements = @agreements.includes(:plan).references(:plans).where("plans.acronym LIKE ?", "%GYRT%") 

    @total_gross_premium = @process_coverages.to_a.sum { |pc| pc.group_remit.gross_premium }
    @total_approved_gross_premium = @approved_pcs.to_a.sum { |pc| pc.group_remit.gross_premium }
    @total_denied_gross_premium = @denied_pcs.to_a.sum { |pc| pc.group_remit.gross_premium }
    @total_pending_gross_premium = @pending_pcs.to_a.sum { |pc| pc.group_remit.gross_premium }

    render :index
  end

  def admin_marketing
    @cooperatives = Cooperative.all
    @agreements = current_user.userable.team.agreements.distinct(:plan)
    @lppi_agreements = @agreements.includes(:plan).where(plan: { acronym: "LPPI" })
    @gyrt_agreements = @agreements.includes(:plan).references(:plans).where("plans.acronym LIKE ?", "%GYRT%")

    @team = current_user.userable.team
    
    render :index
  end

end
