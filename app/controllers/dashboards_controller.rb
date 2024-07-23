class DashboardsController < ApplicationController
    include ProcessClaimHelper

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
      @check_vouchers = Accounting::Check.where(employee: current_user.userable)
      @debit_advices = Accounting::DebitAdvice.where(employee: current_user.userable)
      @journal_vouchers = Accounting::Journal.where(employee: current_user.userable)

      request = Accounting::VoucherRequest.pending
      @check_req = request.check_voucher
      @da_req = request.debit_advice
      @journal_req = request.journal_voucher

      render :index
    end
end
