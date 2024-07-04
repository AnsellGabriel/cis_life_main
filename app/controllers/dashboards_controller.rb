class DashboardsController < ApplicationController
    include ProcessClaimHelper

    def actuarial
        @claim_reinsurance = Claims::ClaimReinsurance.where(status: 0)
        render :index
    end

    def claims
        @user_levels = current_user.user_levels.where(active: 1) if current_user
        @for_evaluation = Claims::ProcessClaim.where(claim_route: get_route_evaluators) if current_user.userable_type == "Employee"
        # unless @claims_user_authority_level == "Claims Evaluator" ||  @claims_user_authority_level == "COSO (Approver)" || @claims_user_authority_level == "President (Approver)"
        #   @for_evaluation = Claims::ProcessClaim.where(claim_route: 3)
        # end
        @coop_messages = Claims::ClaimRemark.where(coop: 1)
        @process_claims = Claims::ProcessClaim.all
        @claim_reinsurances = Claims::ClaimReinsurance.all
        @claims_fund = Claims::CfAccount.all
        render :index
    end

    def coop
        @cooperative = current_user.userable.cooperative
        @notifications = @cooperative.notifications
        @coop_messages = Claims::ClaimRemark.where(coop: 1)
        @process_claims = Claims::ProcessClaim.where(cooperative: @cooperative)
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
      @approved_ors = Treasury::CashierEntry.where(status: :approved, employee: current_user.userable)
      @cancelled_ors = Treasury::CashierEntry.where(status: :cancelled, employee: current_user.userable)
      @for_approval_ors = Treasury::CashierEntry.where(status: :for_approval, employee: current_user.userable)
      @pending_ors = Treasury::CashierEntry.where(status: :pending, employee: current_user.userable)
      @need_approval = Treasury::CashierEntry.where(status: :for_approval)
      @payments = Payment.where(status: :for_review)
      @for_business_checks = Accounting::Check.where(status: :posted, claimable: false, audit: :approved)
      @for_debit_advice = Accounting::DebitAdvice.approved

      render :index
    end
end
