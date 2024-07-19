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
            update_claim_and_tracking(@voucher.voucher_request.requestable, 16)
          end
        elsif params[:remark][:category] == "incorrect_voucher_details"
          @voucher.transaction do
            @voucher.pending!
            @voucher.voucher_request.pending!
          end
        end

      elsif current_user.is_accountant?
        if params[:e_t] == 'request'
          ActiveRecord::Base.transaction do
            @voucher.rejected!
            update_claim_and_tracking(@voucher.requestable, 11)
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

  def update_claim_and_tracking(process_claim, route)
    claim_track = process_claim.process_tracks.build
    claim_track.route_id = route
    claim_track.user_id = current_user.id
    claim_track.save!
    process_claim.update!(
      claim_route: route,
      status: :process
    )
  end
end
