class Audit::ForAuditsController < ApplicationController
  def index
    @vouchers = Accounting::Voucher.pending_for_audit
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
