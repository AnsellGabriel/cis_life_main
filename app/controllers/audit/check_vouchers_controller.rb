class Audit::CheckVouchersController < ApplicationController
  def index
    @vouchers = Accounting::Check.where(status: :posted).where(audit: [:for_audit, :pending_audit]).order(created_at: :desc)
    @pagy, @vouchers = pagy(@vouchers, items: 10)
  end

  def approve
    @voucher = Accounting::Check.find(params[:id])
    @voucher.update(audit: :approved, audited_by: current_user.id)

    claim_track = @voucher.check_voucher_request.requestable.process_track.build
    claim_track.route_id = 15
    claim_track.user_id = current_user.id
    claim_track.save

    redirect_to accounting_check_path(@voucher), notice: "Check Voucher audited and approved"
  end
end
