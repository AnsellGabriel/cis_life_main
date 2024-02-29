class Accounting::RemarksController < ApplicationController

  before_action :initialize_payment, only: %i[index new create show]

  def index
    @remarks = @check.remarks.order(created_at: :desc)
  end

  def show
    @remark = @check.remarks.find(params[:id])
  end

  def new
    @remark = @check.remarks.build
  end

  def create
    @remark = @check.remarks.build(remark_params.merge(user: current_user))

    if @remark.save
      if current_user.is_auditor?
        @check.pending_audit!

        if params[:remark][:category] == "incorrect_claim_details"
          process_claim = @check.check_voucher_request.requestable
          claim_track = process_claim.process_track.build
          claim_track.route_id = 16
          claim_track.user_id = current_user.id
          claim_track.save
          process_claim.update!(claim_route: 1, status: :process, claim_filed: 0, processing: 0, approval: 0, payment: 0)
        elsif params[:remark][:category] == "incorrect_voucher_details"
          @check.pending!
          @check.check_voucher_request.pending!
        end

      elsif current_user.is_accountant?
        @check.cancelled!
        @check.check_voucher_request.pending! if @check.check_voucher_request.present?
      end

      redirect_to accounting_check_remarks_path(@check), Notification: "Voucher updated"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def remark_params
    params.require(:remark).permit(:remark, :category)
  end

  def initialize_payment
    @check = Accounting::Check.find(params[:check_id])
  end

  def import_product_benefit
    if @process_claim.claim_type == ClaimType.find_by(name: "Hospital Confinement Claim")
      @benefit = Benefit.find_by(name: "Hospital Income Benefit")
      @process_claim.claim_benefits.create(process_claim_id: @process_claim.id, benefit: @benefit, amount: @process_claim.claim_confinements.sum(:amount))
    else
      @product_benefit = ProductBenefit.where(agreement_benefit: @process_claim.agreement_benefit)
      @product_benefit.each do | pb |
        @process_claim.claim_benefits.create(process_claim_id: @process_claim.id, benefit_id: pb.benefit_id, amount: pb.coverage_amount)
      end
    end
    @batch = Batch.where(coop_member: @process_claim.claimable, agreement_benefit: @process_claim.agreement_benefit)
    @batch.each do |b|
      @process_claim.claim_coverages.create(process_claim: @process_claim, coverageable: b)
    end
    # @process_claim.claim_benefits.create(
    #   @product_benefit.map { |pb| { process_claim_id: @process_claim.id, benefit_id: pb.benefit_id, amount: pb.coverage_amount } }
    # )
  end
end
