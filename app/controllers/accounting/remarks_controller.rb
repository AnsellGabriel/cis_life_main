class Accounting::RemarksController < ApplicationController
  include Treasuries::Path

  before_action :set_voucher, only: %i[index new create show]

  def index
    @remarks = @voucher.remarks.order(created_at: :desc)
    @voucher_path = entry_path
  end

  def show
    @remark = @voucher.remarks.find(params[:id])
  end

  def new
    @remark = @voucher.remarks.build
    @voucher_path = entry_path
  end

  def create
    @remark = @voucher.remarks.build(remark_params.merge(user: current_user))

    if @remark.save
      if current_user.is_auditor?
        @voucher.pending_audit!

        if params[:remark][:category] == "incorrect_claim_details"
          ActiveRecord::Base.transaction do
            process_claim = @voucher.voucher_request.requestable
            claim_track = process_claim.process_track.build
            claim_track.route_id = 16
            claim_track.user_id = current_user.id
            claim_track.save!
            process_claim.update!(
              claim_route: 1,
              status: :process,
              claim_filed: 0,
              processing: 0,
              approval: 0,
              payment: 0
            )
          end
        elsif params[:remark][:category] == "incorrect_voucher_details"
          @voucher.transaction do
            @voucher.pending!
            @voucher.voucher_request.pending!
          end
        end
      elsif current_user.is_accountant?
        if params[:e_t] == 'request'
          @voucher.transaction do
            @voucher.rejected!
            process_claim = @voucher.requestable
            process_claim.payment_rejected!
            claim_track = process_claim.process_track.build
            claim_track.route_id = 11
            claim_track.user_id = current_user.id
            claim_track.save!
          end
        else
          @voucher.transaction do
            @voucher.general_ledgers.update_all(transaction_date: nil)
            @voucher.cancelled!
            @voucher.voucher_request.pending! if @voucher&.voucher_request&.present?
          end
        end
      elsif current_user.is_treasurer?
        ActiveRecord::Base.transaction do
          @voucher.paid!
          jv_request = VoucherRequestService.new(@voucher, @voucher.amount, :claims_payment, current_user, :journal_voucher)
          jv_request.create_request
        end
      end

      redirect_to accounting_check_remarks_path(@voucher, e_t: @voucher.entry_type)
    else
      @voucher_path = entry_path
      render :new, status: :unprocessable_entity
    end

  end

  private

  def remark_params
    params.require(:remark).permit(:remark, :category)
  end

  def set_voucher
    case params[:e_t]
    when 'cv' then klass = Accounting::Check
    when 'jv' then klass = Accounting::Journal
    when 'da' then klass = Accounting::DebitAdvice
    when 'request' then klass = Accounting::VoucherRequest
    end

    @voucher = klass.find(params[:check_id])
    @entry = @voucher
  end

  # def import_product_benefit
  #   if @process_claim.claim_type == ClaimType.find_by(name: "Hospital Confinement Claim")
  #     @benefit = Benefit.find_by(name: "Hospital Income Benefit")
  #     @process_claim.claim_benefits.create(process_claim_id: @process_claim.id, benefit: @benefit, amount: @process_claim.claim_confinements.sum(:amount))
  #   else
  #     @product_benefit = ProductBenefit.where(agreement_benefit: @process_claim.agreement_benefit)
  #     @product_benefit.each do | pb |
  #       @process_claim.claim_benefits.create(process_claim_id: @process_claim.id, benefit_id: pb.benefit_id, amount: pb.coverage_amount)
  #     end
  #   end
  #   @batch = Batch.where(coop_member: @process_claim.claimable, agreement_benefit: @process_claim.agreement_benefit)
  #   @batch.each do |b|
  #     @process_claim.claim_coverages.create(process_claim: @process_claim, coverageable: b)
  #   end
  #   # @process_claim.claim_benefits.create(
  #   #   @product_benefit.map { |pb| { process_claim_id: @process_claim.id, benefit_id: pb.benefit_id, amount: pb.coverage_amount } }
  #   # )
  # end
end
